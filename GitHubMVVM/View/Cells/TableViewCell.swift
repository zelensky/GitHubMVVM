//
//  TableViewCell.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var starsCountLabel: UILabel!
  
  var viewModel: ResultViewModelProtocol? {
    didSet {
      guard let viewModel = viewModel else {
        return
      }
      self.nameLabel.text = viewModel.getTitle()
      self.starsCountLabel.text = viewModel.getStarsCount()
    }
  }
  
}
