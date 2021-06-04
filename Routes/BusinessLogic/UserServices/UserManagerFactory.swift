//
//  UserManagerFactory.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import Foundation

class UserManagerFactory {
    func makeUserManager() -> UserManager {
        return RealmUser()
    }    
}
