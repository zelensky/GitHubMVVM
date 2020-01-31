//
//  CDResultExtension.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 31.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

extension CDResult: HasTitleLabelText {
  
  var titleLabelText: String? {
    switch (self.name, self.stars) {
    case (.some(let name), 0):
      return "\(name) has no ✸"
    case (.some(let name), let stars) where stars >= 0:
      return "\(name) has \(self.stars) ✸"
    default:
      return nil
    }
  }
  
}
