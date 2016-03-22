//
//  UserTableViewCell.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var companyCatchPhrase: UILabel!
    
    func updateUI() {
        guard let user = user else { return }
        name.text = user.name
        email.text = user.email
        companyCatchPhrase.text = user.company.catchphrase
    }
    
}
