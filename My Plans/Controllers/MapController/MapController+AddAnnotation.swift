//
//  MapController+AddAnnotation.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 10/1/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import Foundation
import MapKit

extension MapController {
    func addAnnotation(latitude:CLLocationDegrees, longitude:CLLocationDegrees, locationTitle:String = "My Location") {
        // Remove Annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        // Create Annotation
        let annotation = MKPointAnnotation()
        annotation.title = locationTitle
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.mapView.addAnnotation(annotation)
        print("\(latitude),\(longitude)")
        // Zoom to Annotation
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
}

