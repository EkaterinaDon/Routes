//
//  RealmService.swift
//  Routes
//
//  Created by Ekaterina on 31.05.21.
//

import Foundation
import RealmSwift
import GoogleMaps

class RealmService {
    
    static let shared = RealmService()
    
    private init(){}
    
    private func save(coordinates: [Coordinate]) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            realm.add(coordinates)
            try realm.commitWrite()
            //debugPrint(realm.configuration.fileURL as Any)
        }
        catch {
            debugPrint("Realm save error: \(error)")
        }
    }
    
    private func getCoordinates() -> [Coordinate]? {
        do {
            let realm = try Realm()
            let result = realm.objects(Coordinate.self)
            return result.count > 0 ? convertToArray(result: result) : nil
        }
        catch {
            debugPrint("Realm get coordinates error: \(error)")
            return nil
        }
    }
    
    private func convertToArray(result: Results<Coordinate>) -> [Coordinate] {
        return result.map({ $0 })
    }
    
    func savePath(from routePath: GMSMutablePath?) {
        guard let coordinates = getCoordinates(from: routePath) else { return }
        save(coordinates: coordinates)
    }
    
    func getPath() -> GMSMutablePath? {
        guard let coordinates = getCoordinates() else { return nil }
        return getPath(from: coordinates)
    }
    
    private func getCoordinates(from routePath: GMSMutablePath?) -> [Coordinate]? {
        guard let path = routePath, path.count() > 0 else { return nil }
        var coordinates = [Coordinate]()
        for i in 0..<path.count(){
            let coordinate = Coordinate()
            coordinate.latitude = path.coordinate(at: i).latitude
            coordinate.longitude = path.coordinate(at: i).longitude
            coordinates.append(coordinate)
        }
        return coordinates
    }
    
    private func getPath(from coordinates: [Coordinate]) -> GMSMutablePath {
        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        return path
    }
    
}
