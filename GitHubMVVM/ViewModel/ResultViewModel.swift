//
//  ResultViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

struct ResultViewModel<T: HasTitleLabelText>: ResultViewModelProtocol {
  
  var result: T
  
  var titleLabelText: String? {
    return result.titleLabelText
  }

  init(result: T) {
    self.result = result
  }
  
}
