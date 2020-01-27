//
//  ResultsViewModelProtocol.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

protocol ResultsViewModelProtocol: class {
  
//  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get }
  
  func numberOfSectins() -> Int
  func numberOfRows(in sectin: Int) -> Int
  func cellViewModel(for indexPath: IndexPath) -> ResultViewModelProtocol?
  func fetch(_ query: String?, complition: @escaping () -> Void)

}
