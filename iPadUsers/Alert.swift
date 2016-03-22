//
//  Alert.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/22/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func showWithTitle(title: String, message: String?, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}