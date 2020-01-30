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
  
  private var viewModel = SearchViewModel<M>()
  private var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: C.self)) as? C,
      let cellViewModel = viewModel.cellViewModel(for: indexPath) else {
        return UITableViewCell()
    }
    
    cell.textLabel?.text = cellViewModel.title()
    return cell
  }
  
  // MARK: - Private funcs
  private func setupTableView() {
    tableView.register(C.self, forCellReuseIdentifier: String(describing: C.self))
  }
  
  private func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.showsSearchResultsButton = true
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  private func updateWith(_ query: String? = nil) {
    viewModel.fetch(query) { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
  // MARK: - SearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    updateWith(searchBar.text)
  }
  
  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    updateWith()
  }
  
}
