//
//  CoreDataManager.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/18/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // Init of coredata stack //
    let persistentContainer:NSPersistentContainer = {
        // Init of coredata stack //
        let persistentContainer = NSPersistentContainer(name: "PlansDataModel")
        // Load Data
        persistentContainer.loadPersistentStores { (dataInfo, err) in
            if let errorStuff = err {
                fatalError("Man shit done hit the fan... check this out \(errorStuff)")
            }
        }
        let context = persistentContainer.viewContext
        return persistentContainer
    }()
    
    
}
