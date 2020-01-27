//
//  ResultViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

struct ResultViewModel: ResultViewModelProtocol {
  
  private let result: SearchResult
  
  init(result: SearchResult) {
    self.result = result
  }

  func getTitle() -> String? {
    guard let name = result.name
      else {
        return nil
    }
    return "\(name) has \(result.stars) ⭐️"
  }
  
}
