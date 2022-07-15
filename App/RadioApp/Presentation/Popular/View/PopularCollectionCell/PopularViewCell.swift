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
  var viewModel: PopularCellViewModel?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setupUI(with viewModel: PopularCellViewModel) {
    self.viewModel = viewModel
    stationImageView.setImage(with: viewModel.imageURL, placeholder: UIImage(named: "radio-default"))
    stationImageView.layer.cornerRadius = 5
    stationImageView.clipsToBounds = true
    stationImageView.contentMode = .scaleAspectFit
  }
}
