//
//  NetworkManager.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
  
  private let searchURL = "https://api.github.com/search/repositories?q=%@&sort=stars"
  private let httpMethod = "GET"
  private var session: URLSession
  
  override init () {
    self.session = URLSession(configuration: URLSessionConfiguration.default)
    super.init()
  }
  
  private func buildRequest(query: String) -> URLRequest? {
    guard let url = URL(string: String(format: searchURL, query)) else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    return request
  }
  
  public func searchRepositories(query: String, complition: @escaping (Data?) -> Void) {
    guard let request = buildRequest(query: query) else {
      return
    }
    
    session.dataTask(with: request) { (data, _, _) in
      complition(data)
    }.resume()
  }
  
}
