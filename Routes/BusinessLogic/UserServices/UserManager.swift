//
//  UserManager.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import Foundation

protocol UserManager {
    func saveUser(with login: String, password: String)
    func getPassword(for login: String) -> String?
    func validateUser(by login: String, and password: String) -> Bool
}
