//
//  PopularViewCell.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularViewCell: UICollectionViewCell {
  
  @IBOutlet weak var stationImageView: UIImageView!
  
  var viewModel: PopularCellViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    guard let viewModel = viewModel else { return }
    
    stationImageView.image = UIImage(named: viewModel.image )
    
    stationImageView.layer.cornerRadius = 5
    stationImageView.clipsToBounds = true
    stationImageView.contentMode = .scaleAspectFit
  }
  
}
