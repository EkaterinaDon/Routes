//
//  RealmUser.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import Foundation
import RealmSwift

class RealmUser: UserManager {
    
    func saveUser(with login: String, password: String) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            //debugPrint(realm.configuration.fileURL as Any)
            guard let user = realm.objects(User.self).filter({ $0.login == login}).first else {
                createUser(with: login, and: password)
                return
            }
            try! realm.write {
                user.password = password
            }
        }
        catch {
            debugPrint("Realm save error: \(error)")
        }
    }
    
    private func getUser(with login: String, and password: String) -> User {
        let user = User()
        user.login = login
        user.password = password
        return user
    }
    
    private func createUser(with login: String, and password: String) {
        let user = getUser(with: login, and: password)
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(user)
            try realm.commitWrite()
        }
        catch {
            debugPrint("Realm create error: \(error)")
        }
    }
    
    func getPassword(for login: String) -> String? {
        do {
            let realm = try Realm()
            guard let user = realm.objects(User.self).filter({ $0.login == login}).first else { return nil }
            return user.password
        }
        catch {
            debugPrint("Realm get password error: \(error)")
            return nil
        }
    }
    
    func validateUser(by login: String, and password: String) -> Bool {
        do {
            let realm = try Realm()
            let users = realm.objects(User.self).filter({ $0.login == login && $0.password == password})
            return users.count > 0
        }
        catch {
            debugPrint("Realm validate error: \(error)")
            return false
        }
    }
    
}
