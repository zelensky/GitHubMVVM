//
//  GitHubModel.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 30.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

struct GitHubModel: Codable {
  
  private let items: [GitHubRepository]
  var importModel: [[String: String]] {
    return items
      .map {
        ["name": $0.name,
         "stars": String(describing: $0.stars)]
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case items
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.items = try container.decode([GitHubRepository].self, forKey: .items)
  }
  
}
  
struct GitHubRepository: Codable {
  
  let name: String
  let stars: Int
  
  enum CodingKeys: String, CodingKey {
    case name, stars = "stargazers_count"
  }
    
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.stars = try container.decode(Int.self, forKey: .stars)
  }
  
}
