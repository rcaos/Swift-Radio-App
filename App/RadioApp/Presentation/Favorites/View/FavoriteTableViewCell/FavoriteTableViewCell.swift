//
//  FavoriteTableViewCell.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Domain
import UIKit
import RxSwift

protocol FavoriteTableViewCellDelegate: AnyObject {
  func favoriteIsPicked(for station: StationProp)
}

class FavoriteTableViewCell: UITableViewCell {

  @IBOutlet weak var stationImageView: UIImageView!
  @IBOutlet weak var nameStationLabel: UILabel!
  @IBOutlet weak var detailStationLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  weak var delegate: FavoriteTableViewCellDelegate?

  private var disposeBag = DisposeBag()

  private var viewModel: FavoriteTableViewModel?

  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = .black
    nameStationLabel.textColor = .white
    
    nameStationLabel.font = Font.proximaNova.of(type: .bold, with: .big)
    detailStationLabel.font = Font.proximaNova.of(type: .regular, with: .normal)
  }

  func setupUI(with viewModel: FavoriteTableViewModel) {
    self.viewModel = viewModel
    setupObservers()
    
    stationImageView.setImage(with: viewModel.imageURL, placeholder: UIImage(named: "radio-default"))
    nameStationLabel.text = viewModel.titleStation
    detailStationLabel.text = viewModel.detailStation
    
    let isFilled = viewModel.isFavorite ? UIImage(named: "btn-favoriteFill") : UIImage(named: "btn-favorite")
    favoriteButton.setImage(isFilled, for: .normal)
  }

  func setupObservers() {
    favoriteButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
  }

  @objc private func tapButton() {
    guard let viewModel = viewModel else {
      return
    }
    delegate?.favoriteIsPicked(for: viewModel.radioStation)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}
