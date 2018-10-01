//
// Created by Jonathan Dowdell on 9/15/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import UIKit
import CoreData

class NoteCell: UITableViewCell {
    
    // Index Path
    var indexPath:IndexPath?
    
    // My Delegate
    var myDelegate:PlansController?

    // Note Container
    let noteContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 90).isActive = true
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 5
        container.layer.shadowOpacity = 0.3
        container.layer.shadowColor = UIColor(red:0.29, green:0.30, blue:0.31, alpha:0.92).cgColor
        container.layer.shadowRadius = 4
        container.layer.shadowOffset = CGSize(width: 0, height: 0)
        container.layer.masksToBounds = false
        return container
    }()

    // Un-Checked Box
     let box: UIButton = {
        let container = UIButton(type: .system)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = true
        container.heightAnchor.constraint(equalToConstant: 30).isActive = true
        container.widthAnchor.constraint(equalToConstant: 30).isActive = true
        container.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
        return container
    }()
    
    // Note Title
    var noteTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taxi ride to hotel"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.30, alpha:1.00)
        return label
    }()
    
    // Clickable View
    let clickableView:UIView = {
        let click = UIView()
        click.translatesAutoresizingMaskIntoConstraints = false
        click.backgroundColor = .clear
        return click
    }()
    
    // Extra
    let extra: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$60"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.30, alpha:1.00)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapGesture = UITapGestureRecognizer()

    private func configureCell() {
        // Note Container
        self.addSubview(noteContainer)
        noteContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noteContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        noteContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        // Un-Check Box
        self.addSubview(box)
        box.centerYAnchor.constraint(equalTo: noteContainer.centerYAnchor).isActive = true
        box.leadingAnchor.constraint(equalTo: noteContainer.leadingAnchor, constant: 16).isActive = true
        box.addTarget(self, action: #selector(boxClicked(_:)), for: .touchUpInside)
        // Note Title
        self.addSubview(noteTitle)
        noteTitle.centerYAnchor.constraint(equalTo: noteContainer.centerYAnchor).isActive = true
        noteTitle.leadingAnchor.constraint(equalTo: box.trailingAnchor, constant: 16).isActive = true
        // Extra
        self.addSubview(extra)
        extra.centerYAnchor.constraint(equalTo: noteContainer.centerYAnchor).isActive = true
        extra.trailingAnchor.constraint(equalTo: noteContainer.trailingAnchor, constant: -16).isActive = true
        self.addSubview(clickableView)
        clickableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        clickableView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        clickableView.leadingAnchor.constraint(equalTo: noteTitle.leadingAnchor).isActive = true
        clickableView.trailingAnchor.constraint(equalTo: extra.leadingAnchor).isActive = true
        clickableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickMe(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        clickableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func clickMe(_ sender: UITapGestureRecognizer) {
        // Create Page
        let planPage:CreatePlanDetailController = CreatePlanDetailController()
        // Set Delegates
        planPage.myDelegate = self.myDelegate
        // Push Data
        planPage.myData = self.myDelegate?.planData[indexPath?.row ?? 0]
        planPage.modalPresentationStyle = .overCurrentContext
        self.window?.rootViewController?.present(planPage, animated: true, completion: {
            UIView.animate(withDuration: 0.2, animations: {
                planPage.view.backgroundColor = UIColor(red:0.28, green:0.15, blue:0.79, alpha:0.90)
            }, completion: nil)
        })
    }
    
    public var dataToEdit:Plans? {
        didSet {
            guard let safeValue = dataToEdit?.checked else { return }
            print("Got Data")
            if safeValue == true {
                print("Setting True")
                UIView.animate(withDuration: 0.3) {
                    self.box.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                    self.checked = true
                }
            } else if safeValue == false {
                print("Setting False")
                UIView.animate(withDuration: 0.3) {
                    self.box.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
                    self.checked = false
                }
            }
        }
    }
    
    
    private var checked:Bool = false {
        didSet {
            if checked == true {
                UIView.animate(withDuration: 0.3) {
                    self.box.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                }
            } else if checked == false {
                UIView.animate(withDuration: 0.3) {
                    self.box.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
                }
            }
        }
    }
    
    @objc private func boxClicked(_ sender:UITapGestureRecognizer) {
        checkedOrNot(check: checked)
    }
    
    private func checkedOrNot(check:Bool) {
        if checked == false {
            checked = true
            dataToEdit?.checked = checked
        } else {
            checked = false
            dataToEdit?.checked = checked
        }
        dataToEdit?.checked = checked
        let context = CoreDataManager.shared.persistentContainer.viewContext
        saveData(context: context)
        
    }
    
    private func saveData(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let err {
            print(err)
        }
    }
}
