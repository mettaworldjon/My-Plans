//
//  MapViewController.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/27/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/////////////////////////////////
// Optionavarelegates //
// MKMapViewDelegate
// UIGestureRecognizerDelegate
// mapView.delegate = self
// lpgr.delegate = self
/////////////////////////////////

class MapController: UIViewController {
    
    ////////////////////
    // Map View
    ////////////////////
    var mapView:MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    ////////////////////
    // Core Location
    ////////////////////
    var locationManager = CLLocationManager()
    
    ////////////////////
    // Search Container
    ////////////////////
    let searchBoxContainer:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 5
        return container
    }()
    
    ////////////////////
    // Search Field
    ////////////////////
    let searchTextField:UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search"
        search.textColor = UIColor(red:0.25, green:0.31, blue:0.40, alpha:1.00)
        search.returnKeyType = .search
        return search
    }()
    
    ////////////////////
    // Search Handlers
    ////////////////////
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    ////////////////////
    // Search Results
    ////////////////////
    let searchResultsTableView:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 5
        table.alpha = 0
        return table
    }()
    let tableID = "searchResults"
    
    ////////////////////
    // Get Location Btn
    ////////////////////
    let findLocation: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(UIImage(named: "navigation"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 1
        return btn
    }()

    ////////////////////
    // Done Btn
    ////////////////////
    let doneButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red:0.01, green:0.48, blue:1.00, alpha:1.00)
        return btn
    }()
    
    ////////////////////
    // Entry Point
    ////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureDropPin()
        configureSearchBox()
        configureButtonsForMap()
        configureSearchResultTable()
        searchCompleter.delegate = self
        configureGps()
    }
    
    ////////////////////
    // Map Setup
    ////////////////////
    func configureMap() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapView.delegate = self
    }
    
    ////////////////////
    // Search Box Setup
    ////////////////////
    func configureSearchBox() {
        view.addSubview(searchBoxContainer)
        searchBoxContainer.safeAreaLayoutGuide.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 16).isActive  = true
        searchBoxContainer.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16).isActive = true
        searchBoxContainer.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16).isActive = true
        searchBoxContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchBoxContainer.addSubview(searchTextField)
        searchTextField.centerXAnchor.constraint(equalTo: searchBoxContainer.centerXAnchor, constant: 0).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: searchBoxContainer.centerYAnchor, constant: 0).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchBoxContainer.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchTextField.delegate = self
    }
    
    ////////////////////
    // Setup Table
    ////////////////////
    func configureSearchResultTable() {
        view.addSubview(searchResultsTableView)
        searchResultsTableView.topAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: 16).isActive = true
        searchResultsTableView.leadingAnchor.constraint(equalTo: searchBoxContainer.leadingAnchor, constant: 0).isActive = true
        searchResultsTableView.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: 0).isActive = true
        searchResultsTableView.heightAnchor.constraint(equalToConstant: 225).isActive = true
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableID)
    }
    
    ////////////////////
    // Setup Done Btn
    ////////////////////
    func configureButtonsForMap() {
        view.addSubview(doneButton)
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -32).isActive = true
        doneButton.addTarget(self, action: #selector(disMissMapView(_:)), for: .touchUpInside)
        view.addSubview(findLocation)
        findLocation.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: 0).isActive = true
        findLocation.topAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: 32).isActive = true
        findLocation.addTarget(self, action: #selector(getLocationButonHandler), for: .touchUpInside)
    }
    
    @objc func getLocationButonHandler() {
        configureGps()
        print("Got here somehow")
    }
    
    ////////////////////
    // Setup Btn Drop
    ////////////////////
    func configureDropPin() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.8
        longPress.delaysTouchesBegan = true
        self.mapView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress (gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint: CGPoint = gestureRecognizer.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        }
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointedCoordinate
        annotation.title = ("My Location")
        mapView.addAnnotation(annotation)
    }
    
    @objc func disMissMapView(_ sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.dismiss(animated: true) {
                print("Done")
            }
        }
    }
}

///////////////////////
// Text Field Delegate
///////////////////////
extension MapController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchCompleter.queryFragment = textField.text ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "")
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 0
        }
        return true
    }
}

///////////////////////
// MapView Delegates
///////////////////////
extension MapController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.view.endEditing(true)
    }
}

///////////////////////
// TableView Delegate
///////////////////////
extension MapController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.textLabel?.textColor = UIColor(red:0.25, green:0.31, blue:0.40, alpha:1.00)
        cell.detailTextLabel?.textColor = UIColor(red:0.25, green:0.31, blue:0.40, alpha:1.00)
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            if let safeCoordinates = coordinate {
                print(safeCoordinates)
                let latitude = safeCoordinates.latitude
                let longitude = safeCoordinates.longitude
                let myLocation = MKPointAnnotation()
                myLocation.title = "My Location"
                myLocation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(myLocation)
                // Zoom to Annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion.init(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                // Remove
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchResultsTableView.alpha = 0
                })
            }
        }
    }
    
    
}

///////////////////////
// Search Delegate
///////////////////////
extension MapController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

///////////////////////
// GPS Location
///////////////////////
extension MapController: CLLocationManagerDelegate {
    
    ///////////////////////
    // Configure Location
    ///////////////////////
    func configureGps() {
        // Set Delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    ///////////////////////
    // Did Update Location
    ///////////////////////
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        // In order to not waste bettery life
        if location.horizontalAccuracy > 0 {
            // Stop Updating
            locationManager.stopUpdatingLocation()
            // Store Values:
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            // Remove and prior Annotations
            self.mapView.removeAnnotations(self.mapView.annotations)
            // Set Starting Point Positioning
            let myLocation = MKPointAnnotation()
            myLocation.title = "My Location"
            myLocation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(myLocation)
            // Zoom to Annotation
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    ///////////////////////
    // Create Annotation
    ///////////////////////
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    
}

