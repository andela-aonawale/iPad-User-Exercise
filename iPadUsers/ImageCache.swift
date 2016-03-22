//
//  ImageCache.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    // MARK: - Properties
    static let sharedInstance = ImageCache()
    
    // prevent initialization
    private init() {}
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Removing images
    
    func deleteImageWithIdentifier(identifier: String) {
        let path = pathForIdentifier(identifier)
        inMemoryCache.removeObjectForKey(path)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier.isEmpty {
            return nil
        }
        
        let path = pathForIdentifier(identifier)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        return fullURL.path!
    }
    
}