//
//  ListViewModelProtocol.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData

protocol ListViewModelProtocol {
  
  var tableViewAction: ((TableViewAction) -> Void)? { get set }
  var view: UIViewController? { get set }
  
  var searchBarIsActive: Bool { get }
  
  func numberOfSectins() -> Int
  func numberOfRows(in sectin: Int) -> Int
  func cellViewModel(for indexPath: IndexPath) -> ListItemViewModelProtocol?
  func didSelectRowAt(indexPath: IndexPath)
  
  func fetch(_ query: String?)

}

extension ListViewModelProtocol {
  
  var searchBarIsActive: Bool {
    return true
  }
  
}
