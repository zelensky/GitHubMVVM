//
//  File.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 30.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

struct SearchModel: ManagedObjectProtocol {
  
  var managedObject: NSManagedObject
  var sortDescriptor: String
  
}
