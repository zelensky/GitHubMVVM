//
//  SearchViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import MagicalRecord

class SearchViewModel<M>: NSObject, SearchViewModelProtocol {
    
  private var results = [M]()
    
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: M.self))
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
    guard let result = fetchedResultsController.object(at: indexPath) as? M else {
      return nil
    }
    return ResultViewModel(result: (result as? CDResult)!)
  }
  
  func fetch(_ query: String?, complition: @escaping () -> Void) {
    
    
//    let vc = CDResult
    
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
    NetworkManager.shared.search(query: query) {  [weak self] data in
      guard let data = data,
        let importModel = (try? JSONDecoder().decode(GitHubModel.self, from: data))?.importModel else {
          return
      }
            
      self?.importToStore(importModel, complition: {
        complition()
      })
      
    }
  }
  
  private func importToStore(_ arrayOfDicts: [[AnyHashable: Any]],
                             complition: @escaping () -> Void) {
    MagicalRecord.save({ managedContext in
      CDResult.mr_import(from: arrayOfDicts, in: managedContext)
    }) { (success, _) in
      guard success else {
        return
      }
      
      complition()
    }
    
  }
  
}
