//
//  ViewController.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData

class GitHubTableViewController: UITableViewController {
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var viewModel: ResultsViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: - Refactor to dependency injection
    viewModel = ResultsViewModel()
    setupSearchController()
  }
  
  // MARK: - DataSourse
  override func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSectins()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows(in: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return {
      let cell = UITableViewCell()
      cell.textLabel?.text = viewModel.cellViewModel(for: indexPath)?.getTitle()
      return cell
      }()
  }
  
  // MARK: - Private funcs
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    
    searchController.searchBar.delegate = self
    
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  
}

extension GitHubTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
  
}


extension GitHubTableViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    guard let query = searchBar.text,
      !query.isEmpty else {
        return
    }
    
    viewModel.search(query: query)
  }
  
}
