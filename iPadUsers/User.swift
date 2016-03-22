//
//  User.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var username: String
    @NSManaged var email: String
    @NSManaged var phone: String
    @NSManaged var website: String
    @NSManaged var address: Address
    @NSManaged var company: Company
    @NSManaged var albums: [Album]
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.id = dictionary["id"] as? NSNumber ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.website = dictionary["website"] as? String ?? ""
        self.address = Address(dictionary: dictionary["address"] as! [String: AnyObject], insertIntoManagedObjectContext: context)
        self.company = Company(dictionary: dictionary["company"] as! [String: AnyObject], insertIntoManagedObjectContext: context)
    }
}