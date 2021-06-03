//
//  MapView.swift
//  Routes
//
//  Created by Ekaterina on 26.05.21.
//

import UIKit
import GoogleMaps

class MapView: UIView {

    // MARK: - Subviews
    
    private(set) lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private(set) lazy var showRouteButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show last route", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13.0)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.addSubview(self.mapView)
        self.addSubview(self.showRouteButton)
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            self.showRouteButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor),
            self.showRouteButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
            self.showRouteButton.widthAnchor.constraint(equalToConstant: 250.0),
            self.showRouteButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}
