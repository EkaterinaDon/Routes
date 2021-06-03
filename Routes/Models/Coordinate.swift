//
//  Coordinate.swift
//  Routes
//
//  Created by Ekaterina on 31.05.21.
//

import Foundation
import RealmSwift

class Coordinate: Object {
    @objc dynamic var longitude: Double = 0
    @objc dynamic var latitude: Double = 0
}
