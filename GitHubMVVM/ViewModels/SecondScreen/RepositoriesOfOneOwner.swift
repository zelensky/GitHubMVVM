//
//  RepositoriesOfOneOwner.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 04.02.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import MagicalRecord

class RepositoriesOfOneOwner<M: NSManagedObject>: NSObject, ListViewModelProtocol, NSFetchedResultsControllerDelegate where M: HasTitleLabelText {
  
  // MARK: ViewModel Protocol
  var view: UIViewController?
  var searchBarIsActive: Bool = false
  var tableViewAction: ((TableViewAction) -> Void)?
  
  // MARK: Private
  private var repositories = [M]()
  private var owner: String?

  private var descriptor = NSSortDescriptor(key: "stars", ascending: false)
  private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
  
  init(_ owner: String) {
    self.owner = owner
    super.init()
    
    //setup NSFetchedResultsController
    let managedContext = NSManagedObjectContext.mr_default()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: M.self))
    let predicate = NSPredicate(format: "owner == %@", owner)
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = [descriptor]
    fetchRequest.fetchLimit = 30
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: managedContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
    fetchedResultsController?.delegate = self
    try? fetchedResultsController?.performFetch()
    
    //Import repos from git
    getRepos()
  }
  
  // MARK: ListViewModelProtocol
  func didSelectRowAt(indexPath: IndexPath) {
  }

  func numberOfSectins() -> Int {
    fetchedResultsController?.sections?.count ?? 0
  }
  
  func numberOfRows(in sectin: Int) -> Int {
    return fetchedResultsController?.sections?[sectin].numberOfObjects ?? 0
  }
  
  func cellViewModel(for indexPath: IndexPath) -> ListItemViewModelProtocol? {
    guard let result = fetchedResultsController?.object(at: indexPath) as? M else {
      return nil
    }
    
    return RepositoryViewModel(result: result)
  }
  
  func fetch(_ query: String?) {
  }
  
  // MARK: FetchedResultsControllerDelegate
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableViewAction?(.beginUpdates)
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableViewAction?(.endUpdates)
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    switch type {
    case .delete:
      guard let indexPath = indexPath else { return }
      tableViewAction?(.delete([indexPath]))
    case .insert:
      guard let indexPath = newIndexPath else { return }
      tableViewAction?(.insert([indexPath]))
    case .move:
      if let indexPath = indexPath {
        tableViewAction?(.delete([indexPath]))
      }
      if let newIndexPath = newIndexPath {
        tableViewAction?(.insert([newIndexPath]))
      }
    case .update:
      break
    @unknown default:
      break
    }
  }
  
  // MARK: Private funcs
  private func getRepos() {
    guard let owner = owner else {
      return
    }
    
    NetworkManager.shared.getAllRepos(owner: owner) { data in
      guard let data = data,
        let repos = try? JSONDecoder().decode([GitHubRepository].self, from: data) else {
          return
      }
      
      let importModel: [[AnyHashable: Any]] = repos
        .map {
          ["name": $0.name,
           "stars": String(describing: $0.stars),
           "owner": $0.owner]
      }
      
      MagicalRecord.save({ managedContext in
        M.mr_import(from: importModel, in: managedContext)
      })
      
    }
    
  }
  
}
