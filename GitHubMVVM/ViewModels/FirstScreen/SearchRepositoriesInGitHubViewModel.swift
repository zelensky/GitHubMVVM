//
//  SearchRepositoriesInGitHubViewModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import MagicalRecord

class SearchRepositoriesInGitHubViewModel<M: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, ListViewModelProtocol where M: HasTitleLabelText {
  
  var view: UIViewController?

  var results = [M]()

  private var descriptor = NSSortDescriptor(key: "stars", ascending: false)
  private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
  
  var tableViewAction: ((TableViewAction) -> Void)?
  
  required override init() {
    super.init()
    //setup NSFetchedResultsController
    let managedContext = NSManagedObjectContext.mr_default()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: M.self))
    fetchRequest.sortDescriptors = [descriptor]
    fetchRequest.fetchLimit = 30
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: managedContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
    fetchedResultsController?.delegate = self
    try? fetchedResultsController?.performFetch()
  }

  // MARK: ViewModel Protocol
  func numberOfSectins() -> Int {
    return fetchedResultsController?.sections?.count ?? 0
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
  
  func didSelectRowAt(indexPath: IndexPath) {
    guard let result = fetchedResultsController?.object(at: indexPath) as? Repository,
      let owner = result.owner else {
        return
    }
    
    let viewModel = RepositoriesOfOneOwner<Repository>(owner)
    let ownersRepositoriesViewController = ListViewController(viewModel: viewModel)
    view?.navigationController?.pushViewController(ownersRepositoriesViewController, animated: true)
  }

  func fetch(_ query: String?) {
    guard let query = query else {
      return
    }
    
    search(query: query) { [weak self] importModel in
      self?.importToStore(importModel)
    }
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
  private func search(query: String, complition: @escaping ([[String: String]]) -> Void) {
    NetworkManager.shared.search(query: query) { data in
      guard let data = data,
        let importModel = (try? JSONDecoder().decode(GitHubModel.self, from: data))?.importModel else {
          return
      }
      
      complition(importModel)
    }
  }
  
  private func importToStore(_ arrayOfDicts: [[AnyHashable: Any]]) {
    MagicalRecord.save({ managedContext in
      M.mr_import(from: arrayOfDicts, in: managedContext)
    })
  }
  
}
