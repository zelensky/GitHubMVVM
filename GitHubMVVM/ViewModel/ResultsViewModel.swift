//
//  ViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import MagicalRecord

class ResultsViewModel<M>: NSObject, ResultsViewModelProtocol {
    
  private let networkManager = NetworkManager()
  private var results = [SearchResult]()
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(M.self)")
    let sortDescriptor = NSSortDescriptor(key: "stars", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchLimit = 30
    let managedContext = NSManagedObjectContext.mr_default()
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    return fetchedResultsController
  }()
  
  // MARK: Protocol
  func numberOfSectins() -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  func numberOfRows(in sectin: Int) -> Int {
    return fetchedResultsController.sections?[sectin].numberOfObjects ?? 0
  }
  
  func cellViewModel(for indexPath: IndexPath) -> ResultViewModelProtocol? {
    guard let searchResult = fetchedResultsController.object(at: indexPath) as? SearchResult else {
      return nil
    }
    return ResultViewModel(result: searchResult)
  }
  
  func fetch(_ query: String?, complition: @escaping () -> Void) {
    
    if let query = query {
      self.search(query: query) { [weak self] in

        //refactor here
        try? self?.fetchedResultsController.performFetch()
        complition()
      }
    } else {
      try? fetchedResultsController.performFetch()
      complition()
    }
    
  }
  
  // MARK: Private funcs
  private func search(query: String, complition: @escaping () -> Void) {
    //refactor here
    networkManager.search(query: query) { [weak self] data in
      guard let data = data,
        let json = try?
          JSONSerialization.jsonObject(with: data,
                                       options: .fragmentsAllowed) as? [String: Any],
        let allResults = json["items"] as? [[String: Any]] else {
          return
      }

      let results = allResults
        .map {
          ["name": $0["name"] as? String ?? "",
           "stars": String($0["stargazers_count"] as? Int ?? 0) ]
      }

      self?.importToStore(results, complition: {
        complition()
      })
    }
    
  }
  
  private func importToStore(_ arrayOfDicts: [[AnyHashable: Any]],
                             complition: @escaping () -> Void) {
    MagicalRecord.save({ managedContext in
      SearchResult.mr_import(from: arrayOfDicts, in: managedContext)
    }) { (success, _) in
      guard success else {
        return
      }
      
      complition()
    }
    
  }
  
}
