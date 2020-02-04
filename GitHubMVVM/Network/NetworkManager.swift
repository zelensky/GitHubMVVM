//
//  NetworkManager.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit

class NetworkManager {
  
  static var shared: NetworkManager {
    let shared = NetworkManager()
    return shared
  }
  
  private var session: URLSession!
  private let searchURL = "https://api.github.com/search/repositories?q=%@&sort=stars"
  private let reposOfOwnerURL = "https://api.github.com/users/%@/repos"
  private let httpMethod = "GET"
  
  private init() {
    session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  func search(query: String, complition: @escaping (Data?) -> Void) {
    guard let url = URL(string: String(format: searchURL, query)) else {
      return
    }
    
    let request = URLRequest(url: url)
    
    session.dataTask(with: request) { (data, _, _) in
      complition(data)
    }.resume()
    
  }
  
  func getAllRepos(owner: String, complition: @escaping (Data?) -> Void) {
    guard let url = URL(string: String(format: reposOfOwnerURL, owner)) else {
      return
    }
    
    let request = URLRequest(url: url)
    session.dataTask(with: request) { (data, _, _) in
      complition(data)
    }.resume()
    
  }
  
}
