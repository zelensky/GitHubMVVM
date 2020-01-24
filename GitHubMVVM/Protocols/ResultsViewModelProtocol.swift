//
//  ResultsViewModelProtocol.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

protocol ResultsViewModelProtocol {
  
  func numberOfRows() -> Int
  func viewModel(for row: Int) -> ResultViewModelProtocol
  func setState(_ state: State)
  func fetch(query: String?, complition: @escaping() -> Void)

}
