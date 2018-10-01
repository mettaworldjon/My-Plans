//
//  HomeViewController.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/14/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import CoreData


class PlansController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreatePlanControllerDelegate {

    // Header
    let viewHeader: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.heightAnchor.constraint(equalToConstant: 200).isActive = true
        header.backgroundColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:1.00)
        return header
    }()

    // Main Title
    let titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Paris Trip"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()

    // Sub Title
    let subTitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Planning out our trip to Paris"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    // Left Button
    let backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.setImage(UIImage(named: "left-arrow"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()

    // Right Button
    let addButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 23).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 23).isActive = true
        btn.setImage(UIImage(named: "plus-button"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    // Table View
    let planTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // Save Protocol Function
    func addPlanToList(plan: Plans) {
        // Update Data
        planData.append(plan)
        // Prepare Row
        let rowToAdd = IndexPath(row: planData.count-1, section: 0)
        planTableView.insertRows(at: [rowToAdd], with: .automatic)
    }
    
    // Edit Protocol Function
    func editPlan(plan: Plans) {
        let numberOfIndex = planData.index(of: plan)
        let indexPath = IndexPath(item: numberOfIndex!, section: 0)
        planTableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    
    // Data Source
    var planData = [Plans]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureLayout()
        configureNavBar()
        configureTableView()
        
    }
    
}
