//
//  Company.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData

class Company: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var name: String
    @NSManaged var catchphrase: String
    @NSManaged var bs: String
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = dictionary["name"] as? String ?? ""
        self.catchphrase = dictionary["catchPhrase"] as? String ?? ""
        self.bs = dictionary["bs"] as? String ?? ""
    }
    
}