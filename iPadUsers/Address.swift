//
//  Address.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData

class Address: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var street: String
    @NSManaged var suite: String
    @NSManaged var city: String
    @NSManaged var zipcode: String
    @NSManaged var geoLocation: GeoLocation
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Address", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.street = dictionary["street"] as? String ?? ""
        self.suite = dictionary["suite"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.zipcode = dictionary["zipcode"] as? String ?? ""
        self.geoLocation = GeoLocation(dictionary: dictionary["geo"] as! [String: AnyObject], insertIntoManagedObjectContext: context)
    }
    
}