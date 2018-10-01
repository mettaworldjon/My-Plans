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

class MapController: UIViewController {
    // Map View
    let mapView:MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsCompass = false
        return map
    }()
    
    // Search Box Container
    let searchBoxContainer:UIView = {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = .white
        box.layer.cornerRadius = 6
        return box
    }()
    
    // Search Textfield
    let searchTextfield:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Search"
        textfield.textColor = UIColor(red:0.25, green:0.31, blue:0.40, alpha:1.00)
        return textfield
    }()
    
    // Done Button
    let doneBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.backgroundColor = UIColor(red:0.01, green:0.48, blue:1.00, alpha:1.00)
        btn.setTitle("Done", for: .normal)
        btn.layer.cornerRadius = 5
        btn.tintColor = .white
        return btn
    }()
    
    // Location Btn
    let findLocationBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(UIImage(named: "navigation"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 1
        return btn
    }()
    
    // Exit Btn
    let exitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(UIImage(named: "exit"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 1
        return btn
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(UIImage(named: "floppy-disk"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 1
        return btn
    }()
    
    
    // Location Manager
    let locationManager = CLLocationManager()
    
    // Search Table View
    let searchResultsTableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 0
        return tableView
    }()
    // Auto Completion
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapControllerConstraints()
        configureLocationManager()
        configureAutoComplete()
    }
    
}

