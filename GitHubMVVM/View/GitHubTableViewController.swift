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
  
  @IBOutlet weak var searchBar: UISearchBar!
  var viewModel: ResultsViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //TODO: - Refactor to dependency injection
    viewModel = ResultsViewModel()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return {
      let cell = UITableViewCell()
      cell.textLabel?.text = ""
      return cell
      }()
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Search Results"
    case 1:
      return "Search History"
    default:
      return nil
    }
  }
  
}
