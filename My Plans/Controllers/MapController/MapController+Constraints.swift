//
//  MapView+Extensions.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 10/1/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit

extension MapController {
    func mapControllerConstraints() {
        // Map View
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        // Search Box Container
        view.addSubview(searchBoxContainer)
        searchBoxContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBoxContainer.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchBoxContainer.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchBoxContainer.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        // Search Textfield
        view.addSubview(searchTextfield)
        searchTextfield.topAnchor.constraint(equalTo: searchBoxContainer.topAnchor, constant: 16).isActive = true
        searchTextfield.leadingAnchor.constraint(equalTo: searchBoxContainer.leadingAnchor, constant: 16).isActive = true
        searchTextfield.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: -16).isActive = true
        searchTextfield.bottomAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: -16).isActive = true
        searchTextfield.delegate = self
        // Done Button
        view.addSubview(doneBtn)
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        doneBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        doneBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneBtn.addTarget(self, action: #selector(dismissAndSave), for: .touchUpInside)
        // Find Location Btn
        view.addSubview(findLocationBtn)
        findLocationBtn.topAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: 32).isActive = true
        findLocationBtn.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: 0).isActive = true
        findLocationBtn.addTarget(self, action: #selector(locationFinderHandler), for: .touchUpInside)
        // Exit Btn
        view.addSubview(exitBtn)
        exitBtn.trailingAnchor.constraint(equalTo: findLocationBtn.trailingAnchor, constant: 0).isActive = true
        exitBtn.topAnchor.constraint(equalTo: findLocationBtn.bottomAnchor, constant: 16).isActive = true
        // Add Long Press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.8
        longPress.delaysTouchesBegan = true
        self.mapView.addGestureRecognizer(longPress)
        // Search Table View
        view.addSubview(searchResultsTableView)
        searchResultsTableView.topAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: 16).isActive = true
        searchResultsTableView.leadingAnchor.constraint(equalTo: searchBoxContainer.leadingAnchor, constant: 0).isActive = true
        searchResultsTableView.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: 0).isActive = true
        searchResultsTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
    }
}
