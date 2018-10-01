//
//  CreatePlanDetailController.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/16/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import CoreData

protocol CreatePlanControllerDelegate {
    func addPlanToList(plan:Plans)
    func editPlan(plan:Plans)
}

class CreatePlanDetailController: UIViewController, UITextViewDelegate {
    
    // Staus Bar Theming
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Container
    let containerView:UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return container
    }()
    var tapGesture = UITapGestureRecognizer()
    var minHeight:NSLayoutConstraint?
    var maxHeight:NSLayoutConstraint?
    // Background
    let background: UIView = {
        let background = UIView()
        background.backgroundColor = .clear
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    // Save Button
    let saveButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(UIImage(named: "checked"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    // More Button
    let moreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        btn.setImage(UIImage(named: "down-arrow"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    var moreButttonTopToSave:NSLayoutConstraint?
    // Button Container
    let buttonContainer:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 28).isActive = true
        container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red:0.57, green:0.57, blue:0.59, alpha:0.80).cgColor
        container.layer.cornerRadius = 28/2
        container.alpha = 0
        return container
    }()
    
    // Cash Button
    let cashButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.setImage(UIImage(named: "dollar1"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 0
        return btn
    }()
    // Location
    let locationButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.setImage(UIImage(named: "location"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 0
        return btn
    }()
    // Add Image
    let addImage: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 13).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 13).isActive = true
        btn.setImage(UIImage(named: "addImage1"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.alpha = 0
        return btn
    }()
    // Title View
    let titleTextView: UITextView = {
        let field = UITextView()
        field.text = "Add your title"
        field.font = UIFont.systemFont(ofSize: 32)
        field.textColor = UIColor(red:0.56, green:0.56, blue:0.57, alpha:1.00)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isScrollEnabled = false
        return field
    }()
    // Description
    let descriptionView:UITextView = {
        let field = UITextView()
        field.text = "Description (optional)"
        field.font = UIFont.systemFont(ofSize: 20)
        field.textColor = .lightGray
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isScrollEnabled = false
        return field
    }()
    // Addon Bubble
    let addOnBubble:UIView = {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.backgroundColor = .darkGray
        bubble.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: 205).isActive = true
        bubble.alpha = 0
        return bubble
    }()
    // Scroll View
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    var scrollViewTopToOrginal:NSLayoutConstraint?
    var scrollViewToAddons:NSLayoutConstraint?
    
    // Collection View
    let addOnCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.alpha = 0
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.heightAnchor.constraint(equalToConstant: 51).isActive = true
        collection.isScrollEnabled = true
        return collection
    }()
    // Collection View Constaints
    
    
    // Register ID
    let collectionCellID = "cellID"
    // Collection Data
    var addOnData = [String]()
    
    
    
    ////////////////////
    // Delegate
    ////////////////////
    var myDelegate:CreatePlanControllerDelegate?
    
    ////////////////////
    // Data for Edit
    ////////////////////
    var myData:Plans? {
        didSet {
            guard let safeTitle = myData?.title else { return }
            titleTextView.text = safeTitle
            guard let safeDescription = myData?.descriptionText else { return }
            descriptionView.text = safeDescription
        }
    }
    
    ////////////////////
    // Toggle On & Off
    ////////////////////
    var toggled:Bool = false
    
    ////////////////////
    // Entry Point
    ////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardListeners()
        configureLayout()
        configureNavBar()
        setupCollectionView()
    }
    
}






