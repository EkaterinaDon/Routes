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
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
