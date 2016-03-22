//
//  Album.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var user: User
    @NSManaged var photos: [Photo]
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Album", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.id = dictionary["id"] as? NSNumber ?? 0
        self.title = dictionary["title"] as? String ?? ""
    }
    
}