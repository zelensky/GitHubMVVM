//
//  ResultViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

struct RepositoryViewModel<T: HasTitleLabelText>: ListItemViewModelProtocol {
  
  var repository: T
  
  var titleLabelText: String? {
    return repository.titleLabelText
  }

  init(result: T) {
    self.repository = result
  }
  
}
