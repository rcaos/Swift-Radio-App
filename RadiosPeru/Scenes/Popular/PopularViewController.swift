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

    @IBOutlet weak var collectionView: UICollectionView!
    
    let interactor = Interactor()
    
    var delegate: MainControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollection()
    }
    
    func setupView() {
        collectionView.backgroundColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
    }
    
    func setupCollection() {
        let nibName = UINib(nibName: "PopularViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - Reactive
    
    func setupBindables() {
        viewModel?.selectedRadioStation = { [weak self] name, group in
            guard let strongSelf = self else { return }
            
            strongSelf.delegate?.mainControllerDelegate(strongSelf, didConfigRadio: name, group: group)
        }
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
