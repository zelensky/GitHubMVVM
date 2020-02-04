//
//  TableViewAction.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 03.02.2020.
//  Copyright © 2020 3. All rights reserved.
//

import UIKit

enum TableViewAction {
  
  case beginUpdates
  case endUpdates
  case delete([IndexPath])
  case insert([IndexPath])
  
}
