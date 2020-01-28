//
//  PlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController, StoryboardInstantiable {
        
    var viewModel: PlayerViewModel!
    
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
    
    var interactor:Interactor? = nil
    
    static func create(with viewModel: PlayerViewModel) -> PlayerViewController {
        let controller = PlayerViewController.instantiateViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    //MARK : - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPlayerView()
        setupGestures()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.refreshStatus()
    }
    
    //MARK: - ViewModel
    
    func setupViewModel() {
        setupViewBindables()
        
        viewModel?.viewState.bind({[weak self] state in
            DispatchQueue.main.async {
                self?.configView(with: state)
            }
        })
        
        viewModel?.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.setupViewBindables()
            }
        }
        
        viewModel?.isFavorite.bindAndFire({ [weak self] favorite in
            DispatchQueue.main.async {
                if favorite {
                    self?.favoriteButton.setImage( UIImage(named: "btn-favoriteFill") , for: .normal)
                } else {
                    self?.favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
                }
            }
        })
    }
    
    func setupViewBindables() {
        guard let viewModel = viewModel else { return }
        
        if let image = viewModel.image {
            stationImageView?.image = UIImage(named: image)
        } else {
            //stationImageView?.image = UIImage(named: "PlaceHolder")
        }
        
        stationNameLabel?.text = viewModel.name
        stationDescriptionLabel?.text = viewModel.getDescription()
    }
    
    //Debería usar la Enum de Radio Player? o solo conocer la ENum de su Model?
    func configView(with state: RadioPlayerState) {
        stationNameLabel.text = viewModel?.name
        stationDescriptionLabel.text = viewModel?.getDescription()
        
        switch state {
        case .stopped, .loading, .buffering, .error(_) :
            playingBarsImage.stopAnimating()
        case .playing :
            playingBarsImage.startAnimating()
        }
        
        configPlayer(with: state)
    }
    
    func configPlayer(with state: RadioPlayerState) {
        switch state {
        case .stopped, .error(_):
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
    
    //MARK: - Setup UI
    
    func setupUI() {
        
        //TODO: COnfig
        //stationImageView
        stationImageView.contentMode = .scaleAspectFit
        
        stationNameLabel.text = ""
        stationNameLabel.textColor = UIColor.white
        stationNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        stationDescriptionLabel.text = ""
        stationDescriptionLabel.textColor = .lightGray
        stationDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        
        // MARK: - TODO Fix autolayout
        // MARK: - Aislarlo en una View Generica
        // Para no importar "MediaPlayer"
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
        
        //TODO
        //Config Stack View Here ..
        
        favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer( panGesture )
        
        let tapForStack = UITapGestureRecognizer(target: self, action: #selector(handleGestureStack(_:)))
        playerStackView.addGestureRecognizer( tapForStack )
    }
 
    //MARK: - Handle Gestures
    
    @objc func handleGestureStack(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        viewModel.togglePlayPause()
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
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
    
    //MARK: - IBActions
    
    @IBAction func tapFavorite(_ sender: Any) {
        guard let  viewModel = viewModel else { return }
        viewModel.markAsFavorite()
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
