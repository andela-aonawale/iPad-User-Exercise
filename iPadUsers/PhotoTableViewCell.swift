//
//  AlbumTableViewCell.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    // cancel task if cell is being reused
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }

}
