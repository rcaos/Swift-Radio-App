//
//  PopularViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PopularViewCell"

class PopularViewController: UIViewController {
    
    var viewModel: PopularViewModel!

    var customView: GenericCollectionView!
    
    let interactor = Interactor()
    
    static func create(with viewModel: PopularViewModel) -> PopularViewController {
        let controller = PopularViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupView()
        setupCollection()
        setupBindables()
    }
    
    func setupCollectionView() {
        customView = GenericCollectionView(frame: view.frame, layout: UICollectionViewFlowLayout() )
        view = customView
    }
    
    func setupView() {
        customView.collectionView.backgroundColor = UIColor(red:55/255, green:55/255, blue:55/255, alpha:1.0)
    }
    
    func setupCollection() {
        let nibName = UINib(nibName: "PopularViewCell", bundle: nil)
        customView.collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        customView.collectionView.dataSource = self
        customView.collectionView.delegate = self
    }
    
    func setupBindables() {
        viewModel?.viewState.bind({ [weak self] state in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.configView(with: state)
            }
        })
        
        viewModel?.getStations()
    }
    
    func configView(with state: PopularViewModel.ViewState) {
        switch state {
        case .populated :
            restoreBackground()
            customView.collectionView.reloadData()
        case .empty :
            setBackground("There are no Stations to Show")
        }
    }
    
    func setBackground(_ message: String) {
        guard let collectionView = customView.collectionView else { return }
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        collectionView.backgroundView = messageLabel;
    }
    
    func restoreBackground() {
        customView.collectionView.backgroundView = nil
    }
    
}

// MARK:- UICollectionViewDataSource

extension PopularViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0}
        return viewModel.popularCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularViewCell
        cell.viewModel = viewModel.popularCells[indexPath.row]
        return cell
    }
}

// MARK:- UICollectionViewDelegate

extension PopularViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.getStationSelection(by: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    //Espacio entre Row y Row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Espacio entre Cells consecutivas
    //Equivale a "flow.minimumInteritemSpacing"
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfRows = CGFloat(3.0)
        
        //Tener en cuenta el espacio entre Cells
        //Por ejemplo 3 cells:
        //          10                 10
        // cell#1 - space -  cell#2 - space - cell#3
        
        let width = collectionView.frame.width / numberOfRows
        
        return CGSize(width: width, height: width)
    }
}
