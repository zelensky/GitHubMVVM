//
//  ResultsViewModelProtocol.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

protocol ResultsViewModelProtocol {
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get }
  
  func numberOfRows() -> Int
  func viewModel(for row: Int) -> ResultViewModelProtocol
  func setState(_ state: State)
  func fetch(query: String?, complition: @escaping() -> Void)

}
