//
//  SearchViewController.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData

class ListViewController<C: UITableViewCell>: UITableViewController, UISearchBarDelegate  {
    
  private var viewModel: ListViewModelProtocol!
  private var searchController: UISearchController!

  init(viewModel: ListViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    
    if viewModel.searchBarIsActive {
      setupSearchController()
    }
    
    viewModel.tableViewAction = updateTableView
    viewModel.view = self
  }
  
  func updateTableView(action: TableViewAction) {
    switch action {
    case .beginUpdates:
      tableView.beginUpdates()
    case .endUpdates:
      tableView.endUpdates()
    case .delete(let indexPaths):
      tableView.deleteRows(at: indexPaths, with: .automatic)
    case .insert(let indexPaths):
      tableView.insertRows(at: indexPaths, with: .automatic)
    }
  }
  
  // MARK: - UITableViewDataSourse
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
    
    cell.textLabel?.text = cellViewModel.titleLabelText
    return cell
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectRowAt(indexPath: indexPath)
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
    viewModel.fetch(query)
  }
  
  // MARK: - SearchBarDelegate
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    updateWith(searchBar.text)
  }
  
  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    updateWith()
  }
  
}
