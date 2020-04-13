//
//  MiniPlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class MiniPlayerViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var playingBarsView: UIImageView!
  
  @IBOutlet weak var stationStackView: UIStackView!
  @IBOutlet weak var stationNameLabel: UILabel!
  @IBOutlet weak var stationDescriptionLabel: UILabel!
  
  @IBOutlet weak var playerStackView: UIStackView!
  
  private var playView: UIView!
  private var loadingView: UIView!
  private var pauseView: UIView!
  
  var viewModel: MiniPlayerViewModel!
  
  static func create(with viewModel: MiniPlayerViewModel) -> MiniPlayerViewController {
    let controller = MiniPlayerViewController.instantiateViewController()
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
  }
  
  // MARK: - Reactive
  
  private func setupViewModel() {
    setupViewBindables()
    
    viewModel.viewState.bind({ [weak self] state in
      DispatchQueue.main.async {
        self?.configView(with: state)
      }
    })
    
    viewModel.updateUI = { [weak self] in
      DispatchQueue.main.async {
        self?.setupViewBindables()
      }
    }
    
    viewModel.isFavorite.bind({ [weak self] favorite in
      DispatchQueue.main.async {
        if favorite {
          self?.favoriteButton.setImage( UIImage(named: "btn-favoriteFill"), for: .normal)
        } else {
          self?.favoriteButton.setImage( UIImage(named: "btn-favorite"), for: .normal)
        }
      }
    })
  }
  
  func setupViewBindables() {
    stationNameLabel.text = viewModel.name
    stationDescriptionLabel.text = viewModel.getDescription()
  }
  
  // MARK: - Change for State Enum but from it viewModel
  
  func configView(with state: RadioPlayerState) {
    stationNameLabel.text = viewModel?.name
    stationDescriptionLabel.text = viewModel?.getDescription()
    
    switch state {
    case .stopped, .loading, .buffering, .error:
      playingBarsView.stopAnimating()
    case .playing :
      playingBarsView.startAnimating()
    }
    configPlayer(with: state)
  }
  
  func configPlayer(with state: RadioPlayerState) {
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
  
  func setupUI() {
    view.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0)
    
    favoriteButton.setImage( UIImage(named: "btn-favorite"), for: .normal)
    
    playingBarsView.image = UIImage(named: "NowPlayingBars-2")
    playingBarsView.autoresizingMask = []
    playingBarsView.contentMode = UIView.ContentMode.center
    playingBarsView.animationImages = PlayingBarsViews.createFrames()
    playingBarsView.animationDuration = 0.6
    
    stationNameLabel.text = ""
    stationNameLabel.textColor = UIColor.white
    stationNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    
    stationDescriptionLabel.text = ""
    stationDescriptionLabel.textColor = .lightGray
    stationDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
  }
  
  func setupPlayerView() {
    setupControlViews()
    setupStackView()
  }
  
  func setupControlViews() {
    let viewForPlay = UIImageView()
    viewForPlay.image = UIImage(named: "but-play")
    viewForPlay.contentMode = .scaleAspectFit
    playView = viewForPlay
    
    let viewForPause = UIImageView(image: UIImage(named: "btn-pause"))
    viewForPause.contentMode = .scaleAspectFit
    pauseView = viewForPause
    
    let size = CGSize(width: 60, height: 36)
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
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureView(_:)))
    view.addGestureRecognizer(tapGesture)
    
    let tapForStack = UITapGestureRecognizer(target: self, action: #selector(handleGestureStack(_:)))
    playerStackView.addGestureRecognizer(tapForStack)
  }
  
  @objc func handleGestureView(_ sender: UITapGestureRecognizer) {
    viewModel.showPlayer()
  }
  
  @objc func handleGestureStack(_ sender: UITapGestureRecognizer) {
    viewModel.togglePlayPause()
  }
  
  @IBAction func tapFavorite(_ sender: Any) {
    viewModel.markAsFavorite()
  }
}
