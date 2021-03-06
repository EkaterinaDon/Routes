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
    let locationManager = LocationManager.instance
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var manualMarker: GMSMarker?
    var isTracking: Bool = false
    
    private var mapView: MapView {
        return self.view as! MapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(stopTrack(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startTrack(sender:)))
    }
    
    override func loadView() {
        self.view = MapView()
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0)
        mapView.mapView.camera = camera
        mapView.mapView.delegate = self
        mapView.showRouteButton.addTarget(self, action: #selector(showTrack(sender:)), for: .touchUpInside)
        
    }

    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self, let location = location else { return }
                self.routePath?.add(location.coordinate)
                self.route?.path = self.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17.0)
                self.mapView.mapView.animate(to: position)
            }
    }
    
    @objc func stopTrack(sender: UIBarButtonItem) {
        stopTracking()
    }
    
    @objc func startTrack(sender: UIBarButtonItem) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView.mapView
        isTracking = true
        locationManager.startUpdatingLocation()
    }
    
    @objc func showTrack(sender: UIButton) {
        if isTracking {
            showAlert()
        } else {
            getLastRoute()
        }

    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        RealmService.shared.savePath(from: routePath)
        isTracking = false
    }
    
    func getLastRoute() {
        guard let lastRoute = RealmService.shared.getPath() else {
            showAlert(title: "Error", message: "You dont have routs yet.")
            return }
        route?.map = nil
        route = GMSPolyline()
        route?.map = mapView.mapView
        route?.path = lastRoute
        route?.strokeColor = .red
        route?.strokeWidth = 3
        let showAllRoute = GMSCameraUpdate.fit(GMSCoordinateBounds(path: lastRoute))
        mapView.mapView.animate(with: showAllRoute)
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
        if let location = locations.last {
            routePath?.add(location.coordinate)
            route?.path = routePath
            let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17.0)
            mapView.mapView.animate(to: position)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

// MARK: - Alert

extension MapViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Stop tracking?", message: "You need to stop tracking route to show route.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.stopTracking()
            self?.getLastRoute()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
