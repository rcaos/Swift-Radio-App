//
//  MiniPlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Domain
import RadioPlayer
import UIKit
import RxSwift

class MiniPlayerViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var playingBarsView: UIImageView!
  
  @IBOutlet weak var stationStackView: UIStackView!
  @IBOutlet weak var stationNameLabel: UILabel!
  @IBOutlet weak var stationDescriptionLabel: UILabel!
  
  @IBOutlet weak var playerStackView: UIStackView!
  
  private var playView: UIView!
  private var loadingView: LoadingPlayerView!
  private var pauseView: UIView!
  
  private var viewModel: MiniPlayerViewModelProtocol!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: MiniPlayerViewModelProtocol) -> MiniPlayerViewController {
    let controller = MiniPlayerViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    setupPlayerView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupGestures()
    setupViewModel()
  }
  
  // MARK: - Reactive
  
  fileprivate  func setupViewModel() {
    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        self?.configView(with: state)
      })
      .disposed(by: disposeBag)

    viewModel.stationName
      .subscribe(onNext: { [weak self] stationName in
        self?.stationNameLabel.text = stationName
      })
      .disposed(by: disposeBag)
    
    viewModel.stationDescription
      .subscribe(onNext: { [weak self] description in
        self?.stationDescriptionLabel.text = description
      })
      .disposed(by: disposeBag)
    
    viewModel.isFavorite
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
  
  fileprivate func configView(with state: RadioPlayerState) {
    switch state {
    case .stopped, .loading, .buffering, .error:
      playingBarsView.stopAnimating()
    case .playing :
      playingBarsView.startAnimating()
    }
    configPlayer(with: state)
  }
  
  fileprivate func configPlayer(with state: RadioPlayerState) {
    switch state {
    case .stopped, .error :
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
  
  fileprivate func setupUI() {
    view.backgroundColor = ColorPalette.customGrayColor
    
    favoriteButton.setImage( UIImage(named: "btn-favorite"), for: .normal)
    
    playingBarsView.image = UIImage(named: "NowPlayingBars-2")
    playingBarsView.autoresizingMask = []
    playingBarsView.contentMode = UIView.ContentMode.center
    playingBarsView.animationImages = PlayingBarsViews.createFrames()
    playingBarsView.animationDuration = 0.6
    
    stationNameLabel.text = ""
    stationNameLabel.textColor = UIColor.white
    stationNameLabel.font = Font.proximaNova.of(type: .bold, with: .custom(22))
    
    stationDescriptionLabel.text = ""
    stationDescriptionLabel.textColor = .lightGray
    stationDescriptionLabel.font = Font.proximaNova.of(type: .regular, with: .normal)
  }
  
  fileprivate func setupPlayerView() {
    setupControlViews()
    setupStackView()
  }
  
  fileprivate func setupControlViews() {
    playView = buildPlayerView()
    
    let viewForPause = UIImageView(image: UIImage(named: "btn-pause"))
    viewForPause.contentMode = .scaleAspectFit
    pauseView = viewForPause
    
    let size = CGSize(width: 48, height: 48)
    let frame = CGRect(origin: .zero, size: size)
    let viewForLoading = LoadingPlayerView(frame: frame)
    viewForLoading.setUpAnimation(size: size, color: .white, imageName: "pauseFill")
    loadingView = viewForLoading
  }
  
  fileprivate func setupStackView() {
    playerStackView.addArrangedSubview(playView)
    playerStackView.addArrangedSubview(pauseView)
    playerStackView.addArrangedSubview(loadingView)
    playerStackView.translatesAutoresizingMaskIntoConstraints = false
    
    playView.isHidden = true
    pauseView.isHidden = true
    loadingView.isHidden = true
  }
  
  fileprivate func setupGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureView(_:)))
    view.addGestureRecognizer(tapGesture)
    
    let tapForStack = UITapGestureRecognizer(target: self, action: #selector(handleGestureStack(_:)))
    playerStackView.addGestureRecognizer(tapForStack)
  }
  
  @objc func handleGestureView(_ sender: UITapGestureRecognizer) {
    viewModel.showFullPlayer()
  }
  
  @objc func handleGestureStack(_ sender: UITapGestureRecognizer) {
    viewModel.togglePlayPause()
  }
  
  @IBAction func tapFavorite(_ sender: Any) {
    self.favoriteButton.favAnimate()
    viewModel.markAsFavorite()
  }
  
  // MARK: - Build Player Views
  
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
