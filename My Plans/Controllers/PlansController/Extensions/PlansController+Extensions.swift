//
// Created by Jonathan Dowdell on 9/15/18.
// Copyright (c) 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import CoreData

extension PlansController {
    
    
    //////////////////////
    // Fetch & Load Data
    //////////////////////
    func fetchData() {
        // Context
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // Target Data
        let targetData = NSFetchRequest<Plans>(entityName: "Plans")
        // Perform Fetch
        do {
            let myPlans = try context.fetch(targetData)
            self.planData = myPlans
            self.planTableView.reloadData()
            myPlans.forEach { (plan) in
                print(plan.title ?? "")
            }
        } catch let errors {
            print(errors)
        }
    }
    
    //////////////////////
    // Setup Nav
    //////////////////////
    func configureNavBar() {
        // Theming
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:1.00)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        // Left Button
        backButton.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
        let leftBtn = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [leftBtn]
        // Right Button
        addButton.addTarget(self, action: #selector(addPlan), for: .touchUpInside)
        let rightBtn = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItems = [rightBtn]
    }
    
    //////////////////////
    // Setup Layout
    //////////////////////
    func configureLayout() {
        // Background
        view.backgroundColor = .white
        // Header
        view.addSubview(viewHeader)
        viewHeader.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        viewHeader.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewHeader.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        // Main Title
        view.addSubview(titleView)
        titleView.centerXAnchor.constraint(equalTo: viewHeader.centerXAnchor).isActive = true
        titleView.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor, constant: -24).isActive = true
        // Sub Title
        view.addSubview(subTitleView)
        subTitleView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        subTitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
        subTitleView.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor, constant: 24).isActive = true
        subTitleView.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor, constant: -24).isActive = true
        subTitleView.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        // Table View
        view.addSubview(planTableView)
        planTableView.topAnchor.constraint(equalTo: viewHeader.bottomAnchor).isActive = true
        planTableView.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor).isActive = true
        planTableView.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor).isActive = true
        planTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    //////////////////////
    // Setup TableView
    //////////////////////
    func configureTableView() {
        // Delegates and Data Source
        planTableView.delegate = self
        planTableView.dataSource = self
        // Register Cells
        planTableView.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
        // Separator
        planTableView.separatorColor = .clear
    }
    
    
    
    
    /* TableView Protocols */
    
    //////////////////////
    // Setup Cell
    //////////////////////
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = planTableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        cell.indexPath = indexPath
        cell.myDelegate = self
        cell.selectionStyle = .none
        cell.noteTitle.text = planData[indexPath.row].title ?? ""
        cell.dataToEdit = planData[indexPath.row]
        return cell
    }
    
    //////////////////////
    // Number of Rows
    //////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planData.count
    }
    
    //////////////////////
    // Row Height
    //////////////////////
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    //////////////////////
    // Header
    //////////////////////
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return header
    }
    //////////////////////
    // Row Actions
    //////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteCell)
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: editCell)
        return [delete,edit]
    }
    
    //////////////////////
    // Click Row
    //////////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //////////////////////
    // Delete Row Action
    //////////////////////
    func deleteCell(action:UITableViewRowAction, indexPath:IndexPath) {
        // Target
        let toDelete = self.planData[indexPath.row]
        print("Deleting \(toDelete.title ?? "")")
        // Remove from Table & Array
        self.planData.remove(at: indexPath.row)
        self.planTableView.deleteRows(at: [indexPath], with: .automatic)
        // Remove from CoreData
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(toDelete)
        // Save
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    //////////////////////
    // Edit Cell Action
    //////////////////////
    func editCell(action:UITableViewRowAction, indexPath:IndexPath) {
        
    }
    
    /* TableView Protocols End */
    
    
    //////////////////////
    // Buttons
    //////////////////////
    
    // Back Button Click
    @objc func backHandler() {
        print("Back to previous page")
    }
    
    // Add Button Click
    @objc func addPlan() {
        // Create Page
        let planPage:CreatePlanDetailController = CreatePlanDetailController()
        // Set Delegate
        planPage.myDelegate = self
        planPage.modalPresentationStyle = .overCurrentContext
        present(planPage, animated: true) {
            UIView.animate(withDuration: 0.2, animations: {
                planPage.view.backgroundColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:0.90)
            }, completion: nil)
        }
    }
}
