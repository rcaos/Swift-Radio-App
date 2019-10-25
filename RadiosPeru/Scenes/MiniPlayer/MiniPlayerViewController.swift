//
//  MiniPlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol MiniPlayerControllerDelegate: class {
    func miniPlayerController(_ miniPlayerViewController: MiniPlayerViewController, didSelectRadio radio: PlayerViewModel)
    
    func miniPlayerController(_ miniPlayerViewController: MiniPlayerViewController, didSelectPlay radio: String)
    
    func miniPlayerController(_ miniPlayerViewController: MiniPlayerViewController, didSelectFavorite radio : String)
}

class MiniPlayerViewController: UIViewController {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var playingBarsView: UIImageView!
    
    @IBOutlet weak var stationStackView: UIStackView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationDescriptionLabel: UILabel!
    
    @IBOutlet weak var playerStackView: UIStackView!
    
    private var playView: UIView!
    private var loadingView: UIView!
    private var pauseView: UIView!
    
    var count = 0
    var favorite: Bool = false {
        didSet {
            if favorite {
                favoriteButton.setImage( UIImage(named: "btn-favoriteFill") , for: .normal)
            } else {
                favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
            }
            toogle()
        }
    }
    
    weak var delegate: MiniPlayerControllerDelegate?
    
    var viewModel: MiniPlayerViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPlayerView()
        setupGestures()
    }
    
    //MARK: - Reactive
    
    private func setupViewModel() {
        setupViewBindables()
        
        viewModel?.updateRadioDetail = {[weak self] in
            self?.setupViewBindables()
        }
    }
    
    func setupViewBindables() {
        guard let viewModel = viewModel else { return }
        
        stationNameLabel.text = viewModel.name
        stationDescriptionLabel.text = viewModel.description
    }
    
    //FIX
    func toogle() {
        count += 1
        
        switch count {
        case 1:
            playView.isHidden = true
            loadingView.isHidden = false
            pauseView.isHidden = true
        case 2:
            playView.isHidden = true
            loadingView.isHidden = true
            pauseView.isHidden = false
        
        default:
            playView.isHidden = false
            loadingView.isHidden = true
            pauseView.isHidden = true
        }
        
        if count == 3 {
            count = 0
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 30 / 255.0, green: 30 / 255.0, blue: 36 / 255.0, alpha: 1.0)
        
        favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
        
        playingBarsView.image = UIImage(named: "NowPlayingBars-2")
        playingBarsView.autoresizingMask = []
        playingBarsView.contentMode = UIView.ContentMode.center
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let tapForStack = UITapGestureRecognizer(target: self, action: #selector(handleGestureStack(_:)))
        playerStackView.addGestureRecognizer(tapForStack)
    }
    
    @objc func handleGestureView(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel, viewModel.isSelected else { return }
        
        delegate?.miniPlayerController(self, didSelectRadio: viewModel.buildPlayerViewModel() )
    }
    
    @objc func handleGestureStack(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel, viewModel.isSelected else { return }
        delegate?.miniPlayerController(self, didSelectPlay: "Press Stack View (Toogle)")
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        guard let  viewModel = viewModel, viewModel.isSelected else { return }
        
        //Esta varaible debería ser Bindable, podría demorar el Servicio
        favorite = !favorite
        
        delegate?.miniPlayerController(self, didSelectFavorite: "selecciono Favorite Button")
    }
}
