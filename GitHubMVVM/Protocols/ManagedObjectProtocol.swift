//
//  ManagedObjectProtocol.swift
//  GitHubMVVM
//
//  Created by Dmytro Zelenskyi on 30.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectProtocol {
  
  var managedObject: NSManagedObject { get set }
  var sortDescriptor: String { get }
  
}
