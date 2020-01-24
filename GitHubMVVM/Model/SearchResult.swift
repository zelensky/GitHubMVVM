//
//  SearchResult.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 21.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case name, stars = "stargazers_count"
  }
  
  let name: String
  let starsCount: String

  init?(_ savedResult: CDSearchResult) {
    self.name = savedResult.name
    self.starsCount = savedResult.starsCount
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.starsCount = try String(container.decode(Int.self, forKey: .stars))
  }
  
}

struct SearchResultResponse: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case items
  }
  
  let items: [SearchResult]
  
}
