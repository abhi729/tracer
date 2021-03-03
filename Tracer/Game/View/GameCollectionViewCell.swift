//
//  GameCollectionViewCell.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import UIKit

protocol GameCollectionViewCellOutput: class {
  func setupName(_ name: String)
}

class GameCollectionViewCell: UICollectionViewCell, GameCollectionViewCellOutput {
  static let identifier = "GameCollectionViewCellIdentifier"

  @IBOutlet weak var nameLabel: UILabel!
  var viewModel: GameCollectionCellViewModel!

  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabel.backgroundColor = UIColor.systemGray6
  }

  func setupName(_ name: String) {
    nameLabel.text = name
    nameLabel.addBorder()
    nameLabel.backgroundColor = UIColor.systemGray6
  }
}
