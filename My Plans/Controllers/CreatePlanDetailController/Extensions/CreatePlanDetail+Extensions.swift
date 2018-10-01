//
//  CreatePlanDetail+Extensions.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/20/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import CoreData


extension CreatePlanDetailController {
    
    ////////////////////
    // Main Layout
    ////////////////////
    func configureLayout() {
        // View
        view.backgroundColor = .clear
        view.isOpaque = false
        // Set Up Container
        view.addSubview(containerView)
        minHeight = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        maxHeight = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9)
        minHeight?.isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tapGesture)
        // Top Dismiss
        view.addSubview(background)
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(dismissUnSaved)))
        // Title View
        view.addSubview(titleTextView)
        [titleTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
         titleTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
         titleTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
         titleTextView.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
        titleTextView.delegate = self
        // Scroll View
        view.addSubview(scrollView)
        scrollViewTopToOrginal = scrollView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 16)
        scrollViewToAddons = scrollView.topAnchor.constraint(equalTo: addOnCollectionView.bottomAnchor, constant: 16)
        scrollViewTopToOrginal?.isActive = true
        scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        scrollView.contentSize = CGSize(width: 100, height: 500)
        // Description View
        scrollView.addSubview(descriptionView)
        descriptionView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        descriptionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        descriptionView.delegate = self
    }
    
    ////////////////////
    // Nav Layout
    ////////////////////
    func configureNavBar() {
        // Save Button
        view.addSubview(saveButton)
        saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        saveButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        saveButton.addTarget(self, action: #selector(dismissSave), for: .touchUpInside)
        // More Button
        view.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(moreOptions), for: .touchUpInside)
        moreButttonTopToSave =  moreButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16)
        moreButton.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor, constant: 0).isActive = true
        moreButttonTopToSave?.isActive = true
        // Button Conatiner
        view.addSubview(buttonContainer)
        buttonContainer.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor).isActive = true
        buttonContainer.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16).isActive = true
        // Cash Button
        view.addSubview(cashButton)
        cashButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        cashButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 10).isActive = true
        cashButton.addTarget(self, action: #selector(addCash(_:)), for: .touchUpInside)
        // Location
        view.addSubview(locationButton)
        locationButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        locationButton.topAnchor.constraint(equalTo: cashButton.bottomAnchor, constant: 10).isActive = true
        locationButton.addTarget(self, action: #selector(addLocation(_:)), for: .touchUpInside)
        // Add Image Button
        view.addSubview(addImage)
        addImage.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        addImage.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 10).isActive = true
        addImage.addTarget(self, action: #selector(moreOptions), for: .touchUpInside)
    }
    
    ////////////////////
    // Listers KB
    ////////////////////
    func keyboardListeners()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    /* Button Handlers */
    
    
    ////////////////////
    // No-Save Dismiss
    ////////////////////
    @objc private func dismissUnSaved(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.4, animations: {
            self.view.endEditing(true)
            self.view.backgroundColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:0.00)
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    ////////////////////
    // Save Dismiss
    ////////////////////
    @objc private func dismissSave() {
        if titleTextView.text != "Add your title" {
            if myData == nil {
                // Load Context
                let context = CoreDataManager.shared.persistentContainer.viewContext
                // Targeting
                let myPlan = NSEntityDescription.insertNewObject(forEntityName: "Plans", into: context)
                // Inserting
                myPlan.setValue("\(titleTextView.text!)", forKey: "title")
                if descriptionView.text != "Description (optional)" {
                    myPlan.setValue("\(descriptionView.text!)", forKey: "descriptionText")
                }
                // Saving Data
                do {
                    try context.save()
                    UIView.animate(withDuration: 0.4, animations: {
                        self.view.endEditing(true)
                        self.view.backgroundColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:0.00)
                    }) { (_) in
                        self.dismiss(animated: true, completion: {
                            self.myDelegate?.addPlanToList(plan: myPlan as! Plans)
                        })
                    }
                } catch let error {
                    print(error)
                }
            } else {
                // Check if Values safe for use
                if let safeTitle = titleTextView.text, let safeDscp = descriptionView.text {
                    // Load Context
                    let context = CoreDataManager.shared.persistentContainer.viewContext
                    // Edit Data
                    myData?.title = safeTitle
                    myData?.descriptionText = safeDscp
                    // Save Data
                    do {
                        try context.save()
                    } catch let error {
                        print(error)
                    }
                    dismiss(animated: true) {
                        self.myDelegate?.editPlan(plan: self.myData!)
                    }
                }
                
            }
        }
    }
    
    ////////////////////
    // More
    ////////////////////
    
    @objc private func moreOptions(_ sender:UITapGestureRecognizer){
        if !toggled {
            UIView.animate(withDuration: 0.2, animations: {
                self.moreButttonTopToSave?.constant = 132
                self.moreButton.transform = self.moreButton.transform.rotated(by: .pi / 1)
                self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.buttonContainer.alpha = 1
                    self.cashButton.alpha = 1
                    self.locationButton.alpha = 1
                    self.addImage.alpha = 1
                    self.toggled = true
                })
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.buttonContainer.alpha = 0
                self.cashButton.alpha = 0
                self.locationButton.alpha = 0
                self.addImage.alpha = 0
                self.toggled = false
            }) { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.moreButttonTopToSave?.constant = 16
                    self.moreButton.transform = self.moreButton.transform.rotated(by: .pi / 1)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    /* Text View Configure */
    
    ////////////////////
    // Change Listener
    ////////////////////
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = titleTextView.sizeThatFits(size)
        titleTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        if descriptionView.isFirstResponder {
            if descriptionView.text.count > 10 {
                UIView.animate(withDuration: 0.3) {
                    self.minHeight?.isActive = false
                    self.maxHeight?.isActive = true
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    ////////////////////
    // Selected
    ////////////////////
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextView.isFirstResponder && titleTextView.text == "Add your title" {
            if titleTextView.textColor == UIColor(red:0.56, green:0.56, blue:0.57, alpha:1.00) {
                titleTextView.textColor = UIColor(red:0.29, green:0.29, blue:0.30, alpha:1.00)
                titleTextView.text = nil
            }
        }
        if descriptionView.isFirstResponder && descriptionView.text == "Description (optional)" {
            if descriptionView.textColor == .lightGray {
                descriptionView.textColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.00)
                // or UIColor(red:0.18, green:0.18, blue:0.19, alpha:1.00)
                descriptionView.text = nil
            }
        }
    }
    
    ////////////////////
    // Not Selected
    ////////////////////
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text.isEmpty {
            titleTextView.text = "Add your title"
            titleTextView.textColor = UIColor(red:0.56, green:0.56, blue:0.57, alpha:1.00)
        }
        if descriptionView.text.isEmpty {
            descriptionView.text = "Description (optional)"
            descriptionView.textColor = .lightGray
        }
        
    }
    
    ////////////////////
    // Max Count
    ////////////////////
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 400
    }
    
    
    ////////////////////
    /* Buttons */
    
    
    ////////////////////
    // Cash Handler
    ////////////////////
    @objc func addCash(_ sender:UITapGestureRecognizer) {
        activateAddon()
        addOnData.append("Budget")
        addOnCollectionView.reloadData()
    }
    
    @objc func addLocation(_ sender:UITapGestureRecognizer) {
        let mapView = MapController()
        present(mapView, animated: true) {
            print("Opened Map")
        }
    }
    
    func activateAddon() {
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollViewTopToOrginal?.isActive = false
            self.scrollViewToAddons?.isActive = true
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.addOnCollectionView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                
            })
        }
    }
    
    ////////////////////
    // Adjust view
    ////////////////////
    @objc func keyboard(notification: Notification) {
        let userinfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    ////////////////////
    // Exit Keyboard
    ////////////////////
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
