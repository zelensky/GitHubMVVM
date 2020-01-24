//
//  CDSearchResult+CoreDataProperties.swift
//  
//
//  Created by Dmytro Zelenskyi on 22.01.2020.
//
//

import Foundation
import CoreData


extension CDSearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSearchResult> {
        return NSFetchRequest<CDSearchResult>(entityName: "CDSearchResult")
    }

    @NSManaged public var name: String
    @NSManaged public var starsCount: String

}
