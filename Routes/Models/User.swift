//
//  User.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
