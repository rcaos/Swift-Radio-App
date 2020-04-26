//
//  PlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift

class PlayerViewController: UIViewController, StoryboardInstantiable {
  
  var viewModel: PlayerViewModel!
  
  @IBOutlet weak var closeButton: UIButton!
  
  @IBOutlet weak var stationImageView: UIImageView!
  @IBOutlet weak var stationNameLabel: UILabel!
  @IBOutlet weak var stationDescriptionLabel: UILabel!
  
  @IBOutlet weak var volumeStackView: UIStackView!
  
  @IBOutlet weak var playingBarsImage: UIImageView!
  @IBOutlet weak var playerStackView: UIStackView!
  @IBOutlet weak var favoriteButton: UIButton!
  
  private var playView: UIView!
  private var loadingView: UIView!
  private var pauseView: UIView!
  
  var interactor: Interactor?
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: PlayerViewModel) -> PlayerViewController {
    let controller = PlayerViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupPlayerView()
    setupGestures()
    setupViewModel()
  }
  
  // MARK: - ViewModel
  
  func setupViewModel() {
    
    viewModel.output.viewState
      .subscribe(onNext: { [weak self] state in
        DispatchQueue.main.async {
          self?.configView(with: state)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.stationURL
      .subscribe(onNext: { [weak self] url in
        self?.stationImageView.setImage(with: url, placeholder: UIImage(named: "radio-default"))
        
      })
      .disposed(by: disposeBag)
    
    viewModel.output.stationName
      .bind(to: stationNameLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.stationDescription
      .bind(to: stationDescriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.isFavorite
      .subscribe(onNext: { [weak self] isFavorite in
        DispatchQueue.main.async {
          let imageFilled = isFavorite ?
            UIImage(named: "btn-favoriteFill") : UIImage(named: "btn-favorite")
          self?.favoriteButton.setImage( imageFilled, for: .normal)
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Change for State Enum but from it viewModel
  
  func configView(with state: RadioPlayerState) {
    switch state {
    case .stopped, .loading, .buffering, .error:
      playingBarsImage.stopAnimating()
    case .playing :
      playingBarsImage.startAnimating()
    }
    
    configPlayer(with: state)
  }
  
  func configPlayer(with state: RadioPlayerState) {
    switch state {
    case .stopped, .error:
      playView.isHidden = false
      loadingView.isHidden = true
      pauseView.isHidden = true
    case .loading :
      playView.isHidden = true
      loadingView.isHidden = false
      pauseView.isHidden = true
    case .playing :
      playView.isHidden = true
      loadingView.isHidden = true
      pauseView.isHidden = false
    case .buffering :
      playView.isHidden = true
      loadingView.isHidden = false
      pauseView.isHidden = true
    }
  }
  
  // MARK: - Setup UI
  
  func setupUI() {
    
    let image = UIImage(named: "btn-close")?.withRenderingMode(.alwaysTemplate)
    closeButton.setImage(image, for: .normal)
    closeButton.tintColor = .white
    
    stationImageView.contentMode = .scaleAspectFit
    
    stationNameLabel.text = ""
    stationNameLabel.textColor = UIColor.white
    stationNameLabel.font = Font.proximaNova.of(type: .bold, with: .custom(22))
    
    stationDescriptionLabel.text = ""
    stationDescriptionLabel.textColor = .lightGray
    stationDescriptionLabel.font = Font.proximaNova.of(type: .regular, with: .normal)
    
    // MARK: - Moved to Generic View, do not import MediaPlayer
    let mpVolumenView = MPVolumeView(frame: volumeStackView.bounds)
    for currentView in mpVolumenView.subviews {
      if currentView.isKind(of: UISlider.self) {
        let tempSlider = currentView as! UISlider
        tempSlider.minimumTrackTintColor = UIColor.white
        tempSlider.maximumTrackTintColor = UIColor.darkGray
      }
    }
    mpVolumenView.showsRouteButton = false
    mpVolumenView.showsVolumeSlider = true
    volumeStackView.addArrangedSubview(mpVolumenView)
    
    playingBarsImage.image = UIImage(named: "NowPlayingBars-2")
    playingBarsImage.autoresizingMask = []
    playingBarsImage.contentMode = UIView.ContentMode.center
    playingBarsImage.animationImages = PlayingBarsViews.createFrames()
    playingBarsImage.animationDuration = 0.6
    
    favoriteButton.setImage( UIImage(named: "btn-favorite"), for: .normal)
  }
  
  func setupPlayerView() {
    setupControlViews()
    setupStackView()
  }
  
  func setupControlViews() {
    playView = buildPlayerView()
    
    let viewForPause = UIImageView(image: UIImage(named: "btn-pause"))
    viewForPause.contentMode = .scaleAspectFit
    pauseView = viewForPause
    
    let size = CGSize(width: playerStackView.frame.width, height: playerStackView.frame.height)
    let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    let viewForLoading = LoadingPlayerView(frame: frame)
    viewForLoading.setUpAnimation(size: size, color: .white, imageName: "pauseFill")
    loadingView = viewForLoading
  }
  
  func setupStackView() {
    playerStackView.addArrangedSubview(playView)
    playerStackView.addArrangedSubview(pauseView)
    playerStackView.addArrangedSubview(loadingView)
    playerStackView.translatesAutoresizingMaskIntoConstraints = false
    
    playView.isHidden = true
    pauseView.isHidden = true
    loadingView.isHidden = true
  }
  
  func setupGestures() {
    
    if #available(iOS 13, *) {
    } else {
      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
      view.addGestureRecognizer( panGesture )
    }
    
    let tapForStack = UITapGestureRecognizer(target: self, action: #selector(handleGestureStack(_:)))
    playerStackView.addGestureRecognizer( tapForStack )
  }
  
  // MARK: - Handle Gestures
  
  @objc func handleGestureStack(_ sender: UITapGestureRecognizer) {
    guard let viewModel = viewModel else { return }
    viewModel.togglePlayPause()
  }
  
  @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    let percentThreshold: CGFloat = 0.3
    
    let translation = sender.translation(in: view)
    let verticalMovement = translation.y / view.bounds.height
    let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
    let downwardMovementPercent = fminf(downwardMovement, 1.0)
    let progress = CGFloat(downwardMovementPercent)
    
    guard let interactor = interactor else { return }
    
    switch sender.state {
    case .began:
      interactor.hasStarted = true
      dismiss(animated: true, completion: nil)
    case .changed:
      interactor.shouldFinish = progress > percentThreshold
      interactor.update(progress)
    case .cancelled:
      interactor.hasStarted = false
      interactor.cancel()
    case .ended:
      interactor.hasStarted = false
      interactor.shouldFinish
        ? interactor.finish()
        : interactor.cancel()
    default:
      break
    }
  }
  
  // MARK: - IBActions
  
  @IBAction func tapFavorite(_ sender: Any) {
    guard let  viewModel = viewModel else { return }
    favoriteButton.favAnimate()
    viewModel.markAsFavorite()
  }
  
  @IBAction func tapClose(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Build Loading Play Button
  
  fileprivate func buildPlayerView() -> UIView {
    let viewForPlay = UIImageView()
    viewForPlay.image = UIImage(named: "but-play")
    viewForPlay.contentMode = .scaleAspectFit
    
    let wrapperView = UIView(frame: .zero)
    viewForPlay.translatesAutoresizingMaskIntoConstraints = false
    wrapperView.addSubview(viewForPlay)
    
    NSLayoutConstraint.activate([
      viewForPlay.widthAnchor.constraint(equalTo: wrapperView.widthAnchor, multiplier: 0.75),
      viewForPlay.heightAnchor.constraint(equalTo: viewForPlay.widthAnchor, multiplier: 1),
      viewForPlay.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
      viewForPlay.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor)
    ])
    return wrapperView
  }
}
