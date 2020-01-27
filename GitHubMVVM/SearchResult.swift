//
//  SearchResult.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 27.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import MagicalRecord

extension SearchResult {
  
  convenience init() {
    self.init()
  }
  
}

struct Res: Decodable {

  enum ItemsCodingKeys: String, CodingKey {
    case items
  }
  
  enum SeachResultsCodingKeys: String, CodingKey {
    case name, stars = "stargazers_count"
  }

  init(from decoder: Decoder) {
    let container = try? decoder.container(keyedBy: ItemsCodingKeys.self)
  }
  
}
