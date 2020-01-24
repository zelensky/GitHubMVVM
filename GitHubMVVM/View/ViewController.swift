//
//  ViewController.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet var viewModel: ResultsViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func updateViewInMainQueue() {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  //MARK: - Actions
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
    
    viewModel.setState(.search)
    viewModel.fetch(query: query) { [weak self] in
      self?.updateViewInMainQueue()
    }
  }
  
  @IBAction func historyPressed(_ sender: Any) {
    viewModel.setState(.history)
    viewModel.fetch { [weak self] in
      self?.updateViewInMainQueue()
    }
  }
  
}

//MARK: - DataSourse
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
