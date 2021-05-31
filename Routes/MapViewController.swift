//
//  MapViewController.swift
//  Routes
//
//  Created by Ekaterina on 26.05.21.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var locationManager: CLLocationManager?
    let geocoder = CLGeocoder()
    var route = [GMSMarker]()
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    private var mapView: MapView {
        return self.view as! MapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Current", style: .plain, target: self, action: #selector(currentLocation(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(updateLocation(sender:)))
    }
    
    override func loadView() {
        self.view = MapView()
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0)
        mapView.mapView.camera = camera
        mapView.mapView.delegate = self
        
    }

    func configureLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    @objc func currentLocation(sender: UIBarButtonItem) {
        guard let locationManager = locationManager else { return }
        locationManager.requestLocation()
        if marker == nil {
            addMarker()
        } else {
            removeMarker()
        }
    }
    
    @objc func updateLocation(sender: UIBarButtonItem) {
        guard let locationManager = locationManager else { return }
        locationManager.startUpdatingLocation()
    }
    
    func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.title = "Hello"
        marker.snippet = "somewhere"
        marker.map = mapView.mapView
        self.marker = marker
    }

    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = "Hi"
            marker.snippet = "Manual Marker"
            self.manualMarker = marker
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.mapView.animate(toLocation: location.coordinate)
            let marker = GMSMarker(position: location.coordinate)
            marker.icon = GMSMarker.markerImage(with: .orange)
            marker.map = mapView.mapView
            marker.title = "Marker \(route.count + 1)"
            geocoder.reverseGeocodeLocation(location) { (places, error) in
                marker.snippet = "\(places?.first?.description ?? "")"
            }
            route.append(marker)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
