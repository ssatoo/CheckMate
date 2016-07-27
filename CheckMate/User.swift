//
//  User.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 12/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userName : String!
    var userId : String!
    var pass : String!
    
    
    func showUser() {
        print("User Pass: \(pass)\nUser ID: \(userId)\nUser Name: \(userName)")
    }

    

}
