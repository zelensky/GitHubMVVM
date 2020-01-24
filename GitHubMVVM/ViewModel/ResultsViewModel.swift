//
//  ViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import MagicalRecord

enum State {
  case search, history
}

class ResultsViewModel: NSObject, ResultsViewModelProtocol {

  @IBOutlet weak var networkManager: NetworkManager!
  private var results = [SearchResult]()
  private var state = State.search
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
    //https://samwize.com/2014/03/29/implementing-nsfetchedresultscontroller-with-magicalrecord/
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDSearchResult")
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let managedContext = NSManagedObjectContext.mr_default()
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    return fetchedResultsController
  }()
  
  func numberOfRows() -> Int {
    results.count
  }
  
  func viewModel(for row: Int) -> ResultViewModelProtocol {
    ResultViewModel(result: results[row])
  }
  
  func setState(_ state: State) {
    self.state = state
  }
  
  func fetch(query: String? = nil, complition: @escaping () -> Void) {
    switch state {
    case .history:
      guard let history = CDSearchResult.mr_findAll() as? [CDSearchResult] else {
        return
      }
      
      self.results = history
        .compactMap { SearchResult($0) }
      complition()
      
    case .search:
      guard let query = query else {
        return
      }
      let decoder = JSONDecoder()
      
      networkManager.searchRepositories(query: query) { data in
        guard let data = data,
          let results = try? decoder.decode(SearchResultResponse.self, from: data) else {
            return
        }
        self.results = results.items
        self.importToCoreData(results.items)
        complition()
      }
      
    }
  }
  
  func importToCoreData(_ serchResults: [SearchResult]) {
    //TODO: - Some problems with array importing
    //fix it in future
    let toImport = serchResults
      .map { ["name": $0.name,
              "starsCount": $0.starsCount] }
    for result in toImport {
      MagicalRecord.save({ managedContext in
        CDSearchResult.mr_import(from: result, in: managedContext)
      })
    }
  }
  
}
