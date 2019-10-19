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
    
    var viewModel = PopularViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
    }
    
    func setupCollection() {
        let nibName = UINib(nibName: "PopularViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK : - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerSegue",
            let destination = segue.destination as? PlayerViewController,
            let index = sender as? Int {
            let _ = destination.view
            destination.viewModel = viewModel.buildModel(for: index)
            destination.transitioningDelegate = self
            destination.interactor = interactor
        }
    }
}

extension PopularViewController : UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularViewCell
        cell.viewModel = viewModel.models[indexPath.row]
        return cell
    }
}

extension PopularViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "playerSegue", sender: indexPath.row)
    }
}

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

extension PopularViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
