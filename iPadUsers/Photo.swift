//
//  Photo.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var thumbnailurl: String
    @NSManaged var album: Album
    @NSManaged var imagepath: String
    
    var image: UIImage? {
        get {
            return ImageCache.sharedInstance.imageWithIdentifier(imagepath)
        }
        set {
            ImageCache.sharedInstance.storeImage(newValue, withIdentifier: imagepath)
        }
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        ImageCache.sharedInstance.deleteImageWithIdentifier(imagepath)
    }
    
    // MARK: - Initialization
    
    convenience init(dictionary: [String: AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.id = dictionary["id"] as? NSNumber ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
        self.thumbnailurl = dictionary["thumbnailUrl"] as? String ?? ""
        self.imagepath = thumbnailurl.componentsSeparatedByString("/").last ?? ""
    }
    
}