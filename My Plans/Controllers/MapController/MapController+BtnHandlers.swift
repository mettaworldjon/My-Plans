//
//  MapController+BtnHandlers.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 10/1/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import Foundation
import MapKit

extension MapController {
    
    // Get Location Btn Handler
    @objc func locationFinderHandler() {
        print("Hello")
        locationManager.startUpdatingLocation()
    }
    
    // Long Press Handler
    @objc func handleLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UILongPressGestureRecognizer.State.began {
            let touchPoint: CGPoint = gestureRecognizer.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            self.mapView.removeAnnotations(self.mapView.annotations)
            addAnnotation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        }
    }
    
    // Dismiss and Save
    @objc func dismissAndSave() {
        UIView.animate(withDuration: 0.5) {
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
}
