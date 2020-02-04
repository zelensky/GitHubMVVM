//
//  Repository.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 31.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

extension Repository: HasTitleLabelText {
  
  var titleLabelText: String? {
    switch (self.name, self.owner, self.stars) {
    case (.some(let name), .some(let owner), 0):
      return "\(name) by \(owner)  has no ✸"
    case (.some(let name), .some(let owner), let stars) where stars >= 0:
      return "\(name) by \(owner) has \(self.stars) ✸"
    default:
      return nil
    }
  }
  
}
