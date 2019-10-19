//
//  PlayerViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel? {
        didSet {
            //Que pasá aquí, El ciclo es diferente porque está en otro StoryBoard??
            //Las variables de la pantalla a;ún no están instanciadas
            setupViewModel()
        }
    }
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationDescriptionLabel: UILabel!
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var playState: Bool = false {
        didSet {
            if playState {
                playButton.setImage( UIImage(named: "btn-pause"), for: .normal)
                playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                playButton.setImage( UIImage(named: "but-play"), for: .normal)
                playButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
    
    //MARK : - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        print("Deinit Player View Controller.")
    }
    
    func setupUI() {
        playButton.setImage( UIImage(named: "but-play"), for: .normal)
        playButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.layer.borderWidth = 2.0
        playButton.layer.borderColor = UIColor.white.cgColor
        
        volumeSlider.minimumTrackTintColor = UIColor.white
        volumeSlider.maximumTrackTintColor = UIColor.darkGray
        
        favoriteButton.setImage( UIImage(named: "btn-favorite") , for: .normal)
    }
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        stationImageView?.image = UIImage(named: viewModel.image)
        stationNameLabel?.text = viewModel.name
        stationDescriptionLabel?.text = viewModel.description
    }
    
    
    @IBAction func tapPlay(_ sender: Any) {
        playState = !playState
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        favorite = !favorite
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
