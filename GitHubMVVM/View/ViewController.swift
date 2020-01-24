//
//  ViewController.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet var viewModel: ResultsViewModel!

  private func updateViewInMainQueue() {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
      self?.activityIndicatorView.stopAnimating()
    }
  }
  
// MARK: Actions
  @IBAction func searchButtonPressed(_ sender: Any) {
    guard let query = searchField.text,
      !query.isEmpty else {
        let alert = UIAlertController(title: "Error",
                                      message: "Type search query",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
        return
    }
    activityIndicatorView.startAnimating()
    viewModel.setState(.search)
    viewModel.fetch(query: query) { [weak self] in
      self?.updateViewInMainQueue()
    }
  }
  
  @IBAction func historyPressed(_ sender: Any) {
    activityIndicatorView.startAnimating()
    viewModel.setState(.history)
    viewModel.fetch { [weak self] in
      self?.updateViewInMainQueue()
    }
  }
  
}

// MARK: DataSource
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)") as? TableViewCell else {
      return UITableViewCell()
    }
    cell.viewModel = viewModel.viewModel(for: indexPath.row)
    return cell
  }
  
}
