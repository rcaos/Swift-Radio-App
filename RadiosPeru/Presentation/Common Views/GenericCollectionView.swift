//
//  GenericCollectionView.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class GenericCollectionView: UIView {
  
  var collectionView: UICollectionView!
  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(frame: CGRect, layout: UICollectionViewLayout) {
    self.init(frame: frame)
    
    setupUI()
    setupCollectionView(with: layout)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private func setupUI() {
    backgroundColor = .white
  }
  
  private func setupCollectionView(with layout: UICollectionViewLayout) {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
  }
  
  private func setupView() {
    addSubview(collectionView)
    NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: topAnchor),
                                 collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                 collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                 collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}
