//
//  FavoriteTableViewCell.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift

protocol FavoriteTableViewCellDelegate: class {
  
  func favoriteIsPicked(for station: StationProp)
}

class FavoriteTableViewCell: UITableViewCell {
  
  @IBOutlet weak var stationImageView: UIImageView!
  @IBOutlet weak var nameStationLabel: UILabel!
  @IBOutlet weak var detailStationLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  weak var delegate: FavoriteTableViewCellDelegate?
  
  private var disposeBag = DisposeBag()
  
  var viewModel: FavoriteTableViewModel? {
    didSet {
      setupUI()
      setupObservers()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = .black
    nameStationLabel.textColor = .white
    
    nameStationLabel.font = Font.proximaNova.of(type: .bold, with: .big)
    detailStationLabel.font = Font.proximaNova.of(type: .regular, with: .normal)
  }
  
  func setupUI() {
    guard let viewModel = viewModel else { return }
    
    stationImageView.setImage(with: viewModel.imageURL, placeholder: UIImage(named: "radio-default"))
    nameStationLabel.text = viewModel.titleStation
    detailStationLabel.text = viewModel.detailStation
    
    let isFilled = viewModel.isFavorite ? UIImage(named: "btn-favoriteFill") : UIImage(named: "btn-favorite")
    favoriteButton.setImage(isFilled, for: .normal)
  }
  
  func setupObservers() {
    favoriteButton.rx.tap
      .bind { [weak self] in
        guard let strongSelf = self,
          let viewModel = strongSelf.viewModel else { return }
        strongSelf.delegate?.favoriteIsPicked(for: viewModel.radioStation)
    }
    .disposed(by: disposeBag)
  }
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}
