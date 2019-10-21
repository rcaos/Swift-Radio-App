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
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var playerButton: UIButton!
    
    var playState: Bool = false {
        didSet {
            if playState {
                playerButton.setImage( UIImage(named: "btn-pause"), for: .normal)
                playerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                playerButton.setImage( UIImage(named: "but-play"), for: .normal)
                playerButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
    }
    
    var favorite: Bool = false {
        didSet {
            if favorite {
                favoriteButton.setImage( UIImage(named: "btn-favoriteFill") , for: .normal)
            } else {
                favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
            }
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
        
        stationNameLabel.text = viewModel.fullName
    }
    
    func setupUI() {
        
        //view.backgroundColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 30 / 255.0, green: 30 / 255.0, blue: 36 / 255.0, alpha: 1.0)
        
        
        favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
        
        playerButton.setImage( UIImage(named: "but-play"), for: .normal)
        playerButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        playerButton.layer.cornerRadius = playerButton.frame.size.height / 2
        playerButton.layer.borderWidth = 2.0
        playerButton.layer.borderColor = UIColor.white.cgColor
        
        stationNameLabel.textColor = UIColor.white
        stationNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        //Only for Test
        //stationNameLabel.text = "Pick a Radio Station"
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleGesture(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel, viewModel.isSelected else { return }
        
        delegate?.miniPlayerController(self, didSelectRadio: viewModel.buildPlayerViewModel() )
    }
    
    //MARK: - IBActions
    @IBAction func tapButton(_ sender: Any) {
        guard let viewModel = viewModel, viewModel.isSelected else { return }
        
        //Esta variable debería ser Bindable, Loading, Buffering, etc
        playState = !playState
        
        delegate?.miniPlayerController(self, didSelectPlay: "selecciono Play Button")
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        guard let  viewModel = viewModel, viewModel.isSelected else { return }
        
        //Esta varaible debería ser Bindable, podría demorar el Servicio
        favorite = !favorite
        
        delegate?.miniPlayerController(self, didSelectFavorite: "selecciono Favorite Button")
    }
}
