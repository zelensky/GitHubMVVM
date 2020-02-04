//
//  RepositoriesOfOneOwner.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 04.02.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

struct RepositoriesOfOneOwner<M: NSManagedObject>: ListViewModelProtocol where M: HasTitleLabelText {
  
  var tableViewAction: ((TableViewAction) -> Void)?
  
  init() {
    
  }
  
  private var repositories = [M]()
  
  var searchBarIsActive: Bool = false
  
  func numberOfSectins() -> Int {
    1
  }
  
  func numberOfRows(in sectin: Int) -> Int {
    repositories.count
  }
  
  func cellViewModel(for indexPath: IndexPath) -> ListItemViewModelProtocol? {
    
    return nil
  }
  
  func fetch(_ query: String?) {
  }
  
}
