//
//  MapController+Location.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 10/1/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import CoreLocation

extension MapController: CLLocationManagerDelegate {
    
    // Configure Location Manager
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // On Location of GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get Strongest Signal
        let location = locations[locations.count - 1]
        // Check if Location Data is Valid
        if location.horizontalAccuracy > 0 {
            // To preserve Battery life
            locationManager.stopUpdatingLocation()
            // Store Location Data
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Add Annotation
            addAnnotation(latitude: latitude, longitude: longitude)
        }
    }
}
