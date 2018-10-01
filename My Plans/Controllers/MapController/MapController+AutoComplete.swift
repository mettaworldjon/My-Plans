//
//  MapController+AutoComplete.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 10/1/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import Foundation
import MapKit

extension MapController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchCompleter.queryFragment = textField.text ?? ""
        return true
    }
}

extension MapController:MKLocalSearchCompleterDelegate {
    
    // Set Delegate
    func configureAutoComplete() {
        searchCompleter.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = searchCompleter.results
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 1
        }
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension MapController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension MapController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            guard let safeLatitude = coordinate?.latitude else { return }
            guard let safeLongitude = coordinate?.longitude else { return }
            self.addAnnotation(latitude: safeLatitude, longitude: safeLongitude, locationTitle: tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "")
            UIView.animate(withDuration: 0.3) {
                self.searchResultsTableView.alpha = 0
                self.searchTextfield.text = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""
                self.searchTextfield.endEditing(true)
            }
        }
        
        
        
    }
}
