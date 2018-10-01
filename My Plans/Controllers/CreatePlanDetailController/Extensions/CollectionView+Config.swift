//
//  CollectionView.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/22/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit

////////////////////
// CollectionView
////////////////////
extension CreatePlanDetailController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    ////////////////////
    // Setup
    ////////////////////
    func setupCollectionView() {
        // Register
        addOnCollectionView.register(collectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        // Delegates and Datasource
        addOnCollectionView.delegate = self
        addOnCollectionView.dataSource = self
        // Layout
        view.addSubview(addOnCollectionView)
        addOnCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        addOnCollectionView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 16).isActive = true
        addOnCollectionView.trailingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: -10).isActive = true
    }
    
    
    
    
    ////////////////////
    // Protocols
    ////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addOnData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if addOnData[indexPath.row] == "Budget" {
            print("Rendering Budget Cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! collectionViewCell
            return cell
        }
        
        if addOnData[indexPath.row] == "Location" {
            print("Rendering Location Cell")
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 99, height: 50)
    }
    
    
}
