//
//  SearchViewController.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController<C: UITableViewCell, M: NSManagedObject>: UITableViewController, UISearchBarDelegate {
  
  private var viewModel = ResultsViewModel<M>()
  private var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchController = UISearchController(searchResultsController: nil)
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? C else {
      let cell = UITableViewCell()
      cell.textLabel?.text = viewModel.cellViewModel(for: indexPath)?.getTitle()
      return cell
    }
    cell.textLabel?.text = viewModel.cellViewModel(for: indexPath)?.getTitle()
    return cell
  }
  
  // MARK: - Private funcs
  private func setupSearchController() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.showsSearchResultsButton = true
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  private func updateWith(_ query: String?) {
    viewModel.fetch(query) { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    updateWith(searchBar.text)
  }
  
  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    updateWith(nil)
  }
  
}
