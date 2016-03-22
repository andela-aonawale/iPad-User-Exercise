//
//  Extensions.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    /// Get the navigation controller's top view controller
    /// or the navigation controller  itself if the
    /// top view controller is nil
    /// - Returns: UIViewController
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.topViewController ?? self
        }
        return self
    }
}

// MARK: - Core Data Saving support

extension NSManagedObjectContext {
    func saveContext() {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}