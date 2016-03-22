//
//  Coordinate.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData

class GeoLocation: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("GeoLocation", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
    }
    
}