//
//  ApiPlayer.swift
//  RadiosPeru
//
//  Created by Jeans on 10/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import AVFoundation

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

class ApiPlayer : NSObject{
    
    //MARK: - Public
    public static let shared = ApiPlayer()
    
    weak var delegate: ApiPlayerDelegate?
    
    var status: ApiPlayerState = .initial {
        didSet {
            delegate?.apiPlayerDelegate(didChangeState: status)
        }
    }
    
    //MARK: - Private
    private var player: AVPlayer
    
    private var currentPlayerItemObserver: NSObjectProtocol?
    
    private var lastURL: URL?
    
    private var currentPlayerItem: AVPlayerItem? {
        didSet {
            didSetPlayerItem(oldValue)
        }
    }
    
    //TO DO
    private var isHeadPhonesConnected = false
    private var isInterrupted = false
    private var isConnected = false
    
    //MARK: - Initialization
    
    override private init() {
        player = AVPlayer()
        super.init()
        player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
    }
    
    //MARK: - Public Control Methods
    
    public func prepare(with url: URL, playWhenReady: Bool = false) {
        
        if let currentItem = currentPlayerItem {
            //It's the same URL
            if let currentURL = (currentItem.asset as? AVURLAsset)?.url ,
                currentURL == url {
                //print("Es la misma URl radio. No hacer nada")
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
        print("--Api.play()")
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
    
    public func pause(manually: Bool) {
        switch status {
        case .preparing(let playWhenReady):
            if playWhenReady {
                status = .preparing(playWhenReady: false)
            }
        case .playing, .buffering:
            status = .paused(manually: manually)
            player.pause()
        case .initial, .paused, .stopped, .error:
            break
        }
    }
    
    public func togglePlayPause() {
        print("Toogle for status: [\(status)]")
        switch status {
        case .paused, .stopped, .error:
            play()
        default :
            stop()
        }
    }
    
    //MARK: - Private Methods
    
    private func didSetPlayerItem(_ oldPlayerItem: AVPlayerItem?) {
        removeObservers(for: oldPlayerItem)
        addObservers(for: currentPlayerItem)
    }
    
    private func removeObservers(for item: AVPlayerItem?) {
        guard let item = item else { return }
        print("--Remove Observers for: \((item.asset as? AVURLAsset)?.url)")
        item.removeObserver(self, forKeyPath: "status")
    }
    
    private func addObservers(for item: AVPlayerItem?) {
        guard let item = item else { return }
        print("--Add Observers for:\((item.asset as? AVURLAsset)?.url)")
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

extension ApiPlayer {
    
    //MARK: - KVO Apple
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else { return }
        guard let object = object as AnyObject? else { return }
        
        DispatchQueue.main.async {
            if self.player === object {
                if keyPath == "timeControlStatus" {
                    self.playerDidChangeTimeControlStatus()
                }
            }
            else if let item = object as? AVPlayerItem {
                guard item === self.currentPlayerItem else { return }
                
                if keyPath == "status" {
                    self.playerItemDidChangeStatus(item)
                }
            }
        }
    }
    
    private func playerItemDidChangeStatus(_ item : AVPlayerItem) {
        //Check Apple documentation
        //case unknown: The item’s status is unknown.
        //case readyToPlay: The item is ready to play.
        //case failed: The item no longer plays due to an error.
        
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
            print("\n(Item status failed: \(item.error))")
            status = .error
        case .unknown:
            print("(\nItem status unknown)")
            status = .error
        @unknown default:
            print("\n(Unknow statue)")
            status = .error
        }
    }
    
    private func playerDidChangeTimeControlStatus() {
        //Check Apple documentation
        //case paused : The player is paused.
        //case waitingToPlayAtSpecifiedRate :The player is in a waiting state due to empty buffers or insufficient buffering.
        //case playing: The player is currently playing a media item.
        
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
