//
//  ApiPlayer.swift
//  RadiosPeru
//
//  Created by Jeans on 10/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

enum ApiPlayerState {
  case initial
  case preparing(playWhenReady: Bool) //Reproducir automáticamente
  case playing
  case buffering
  case paused(manually: Bool)     //Si el usuario Manualmente lo pausó
  case stopped    //El sistema paró reproducción
  case error
}

protocol ApiPlayerDelegate: class {
  func apiPlayerDelegate(didChangeState state: ApiPlayerState)
}

class ApiPlayer: NSObject {
  
  // MARK: - Public
  
  public static let shared = ApiPlayer()
  
  weak var delegate: ApiPlayerDelegate?
  
  private var status: ApiPlayerState = .initial {
    didSet {
      delegate?.apiPlayerDelegate(didChangeState: status)
      updateNowPlayingInfo()
    }
  }
  
  // MARK: - Private
  
  private var player: AVPlayer
  
  private var currentPlayerItemObserver: NSObjectProtocol?
  
  private var lastURL: URL?
  
  private var currentPlayerItem: AVPlayerItem? {
    didSet {
      didSetPlayerItem(oldValue)
    }
  }
  
  var dataSource: PlayerDataSource? {
    didSet {
      updateNowPlayingInfo()
    }
  }
  
  private var isHeadPhonesConnected = false
  private var isInterrupted = false
  private var isConnected = false
  
  // MARK: - Initialization
  
  override private init() {
    
    // MARK: - TODO: Check other optiones, bluetooth? airPlay?, .mixWithOthers
    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.defaultToSpeaker])
    try? audioSession.setMode(AVAudioSession.Mode.default)
    try? audioSession.setActive(true)
    
    player = AVPlayer()
    super.init()
    player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
    
    NotificationCenter.default.addObserver(
      forName: AVAudioSession.interruptionNotification,
      object: nil,
      queue: .main,
      using: handleAudioSessionInterruptionNotification)
    
    setupRemoteCommandCenter()
  }
  
  // MARK: - Public Control Methods
  
  public func prepare(with url: URL, playWhenReady: Bool = false) {
    
    if let currentItem = currentPlayerItem {
      if let currentURL = (currentItem.asset as? AVURLAsset)?.url ,
        currentURL == url {
        return
      }
      
      stop()
    }
    
    currentPlayerItem = nil
    status = .preparing(playWhenReady: playWhenReady)
    
    currentPlayerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: currentPlayerItem)
    
    lastURL = url
  }
  
  public func stop() {
    player.pause()
    player.replaceCurrentItem(with: nil)
    currentPlayerItem = nil
    status = .stopped
  }
  
  public func play() {
    switch status {
    case .paused, .preparing:
      player.play()
    case .stopped:
      if let lastURL = lastURL, currentPlayerItem == nil {
        prepare(with: lastURL, playWhenReady: true)
      }
    case .initial, .playing, .buffering, .error:
      break
    }
  }
  
  public func togglePlayPause() {
    switch status {
    case .paused, .stopped:
      play()
    case .error:
      stop()
      play()
    default :
      stop()
    }
  }
  
  // MARK: - Private Methods
  
  private func didSetPlayerItem(_ oldPlayerItem: AVPlayerItem?) {
    removeObservers(for: oldPlayerItem)
    addObservers(for: currentPlayerItem)
  }
  
  private func removeObservers(for item: AVPlayerItem?) {
    guard let item = item else { return }
    item.removeObserver(self, forKeyPath: "status")
  }
  
  private func addObservers(for item: AVPlayerItem?) {
    guard let item = item else { return }
    item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    
    if let observer = currentPlayerItemObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                           object: item, queue: .main, using: { [weak self] note in
                                            
                                            print("Terminó conecction ??")
                                            guard let object = note.object as AnyObject? else { return }
                                            guard object === self?.currentPlayerItem else { return }
                                            
                                            self?.stop()
    })
  }
}

// MARK: - KVO Apple

extension ApiPlayer {
  
  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey: Any]?,
                                    context: UnsafeMutableRawPointer?) {
    
    guard let keyPath = keyPath else { return }
    guard let object = object as AnyObject? else { return }
    
    DispatchQueue.main.async {
      if self.player === object {
        if keyPath == "timeControlStatus" {
          self.playerDidChangeTimeControlStatus()
        }
      } else if let item = object as? AVPlayerItem {
        guard item === self.currentPlayerItem else { return }
        
        if keyPath == "status" {
          self.playerItemDidChangeStatus(item)
        }
      }
    }
  }
  
  private func playerItemDidChangeStatus(_ item: AVPlayerItem) {
    // MARK: - Check Apple documentation
    // case unknown: The item’s status is unknown.
    // case readyToPlay: The item is ready to play.
    // case failed: The item no longer plays due to an error.
    
    switch item.status {
    case .readyToPlay:
      if case .preparing(let shouldPlay) = status {
        if shouldPlay {
          play()
        } else {
          self.status = .paused(manually: true)
        }
      }
      
    case .failed:
      status = .error
    case .unknown:
      status = .error
    @unknown default:
      status = .error
    }
  }
  
  private func playerDidChangeTimeControlStatus() {
    // MARK: - Check Apple documentation
    // case paused : The player is paused.
    // case waitingToPlayAtSpecifiedRate :The player is in a waiting state due to empty buffers or insufficient buffering.
    // case playing: The player is currently playing a media item.
    
    switch player.timeControlStatus {
    case .paused:
      switch status {
      case .paused, .initial, .error, .preparing, .stopped:
        break
      case .playing, .buffering:
        status = .paused(manually: false)
      }
    case .playing:
      status = .playing
      
    case .waitingToPlayAtSpecifiedRate:
      switch status {
      case .initial, .error, .preparing, .stopped:
        break
      case .buffering, .playing, .paused:
        status = .buffering
      }
    @unknown default:
      print("unknown state")
    }
  }
}

// MARK: - Handle Interruptions

extension ApiPlayer {
  
  fileprivate func handleAudioSessionInterruptionNotification(note: Notification) {
    
    guard let typeNumber = note.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber else {return}
    guard let type = AVAudioSession.InterruptionType(rawValue: typeNumber.uintValue) else { return }
    
    switch type {
      
    case .began:
      stop()
      
    case .ended:
      let optionNumber = note.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber
      if let number = optionNumber {
        let options = AVAudioSession.InterruptionOptions(rawValue: number.uintValue)
        let shouldResume = options.contains(.shouldResume)
        
        if shouldResume {
          play()
        }
      }
    @unknown default:
      print("No Implementation")
    }
    
  }
}

// MARK: - Remote Commands

extension ApiPlayer {
  
  func setupRemoteCommandCenter() {
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.nextTrackCommand.isEnabled = false
    commandCenter.previousTrackCommand.isEnabled = false
    commandCenter.playCommand.isEnabled = true
    commandCenter.pauseCommand.isEnabled = true
    
    commandCenter.playCommand.addTarget { [weak self] _ in
      self?.togglePlayPause()
      return .success
    }
    
    commandCenter.pauseCommand.addTarget { [weak self] _ in
      self?.togglePlayPause()
      return .success
    }
  }
}

// MARK: - Now Playing Info

extension ApiPlayer {
  
  fileprivate func updateNowPlayingInfo() {
    guard let dataSource = dataSource else { return }
    
    var info: [String: Any]? = [:]
    
    switch status {
    case .playing :
      info = dataSource.nowPlayInfo()
    default :
      info = dataSource.nowDefaultInfo()
    }
    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
  }
  
}
