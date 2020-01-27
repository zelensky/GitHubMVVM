//
//  ViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import MagicalRecord

class ResultsViewModel: NSObject, ResultsViewModelProtocol {
  
  var networkManager: NetworkManager!
  private var results = [SearchResult]()
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchResult")
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let managedContext = NSManagedObjectContext.mr_default()
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    return fetchedResultsController
  }()
  
  override init() {
    super.init()
    
    networkManager = NetworkManager()
    
    //    createRecord()
    try? fetchedResultsController.performFetch()
  }
  
  //Temp
  func createRecord() {
    let result = SearchResult.mr_createEntity()
    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
  }
  
  func numberOfSectins() -> Int {
    1
  }
  
  func numberOfRows(in sectin: Int) -> Int {
    return fetchedResultsController.sections?[0].numberOfObjects ?? 0
  }
  
  func cellViewModel(for indexPath: IndexPath) -> ResultViewModelProtocol? {
    guard let searchResult = fetchedResultsController.object(at: indexPath) as? SearchResult else {
      return nil
    }
    return ResultViewModel(result: searchResult)
  }
  
  func search(query: String) {
    
    //TODO: - Refactor
    networkManager.search(query: query) { data in
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
      
      self.importToPersistentStore(results)
    }
    
  }
  
  func importToPersistentStore(_ arrayOfDicts: [[AnyHashable : Any]] ) {
    MagicalRecord.save({ managedContext in
      SearchResult.mr_import(from: arrayOfDicts, in: managedContext)
    }) { (success, _) in
      guard success else {
        return
      }
      
      print(success)
    }

  }
  
}
