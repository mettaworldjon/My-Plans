//
//  CollectionViewCell.swift
//  My Plans
//
//  Created by Jonathan Dowdell on 9/22/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit

class collectionViewCell: UICollectionViewCell {
    
    let bubble:UIView = {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: 100).isActive = true
        bubble.layer.borderWidth = 1
        bubble.layer.borderColor = UIColor(red:0.91, green:0.91, blue:0.92, alpha:1.00).cgColor
        bubble.layer.cornerRadius = 10
        return bubble
    }()
    
    let dollarSign:UILabel = {
        let sign = UILabel()
        sign.translatesAutoresizingMaskIntoConstraints = false
        sign.text = "$"
        sign.textColor = UIColor(red:0.75, green:0.76, blue:0.76, alpha:1.00)
        return sign
    }()
    
    let moneyTextField:UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .decimalPad
        field.textColor = UIColor(red:0.05, green:0.05, blue:0.06, alpha:1.00)
        field.font = UIFont.systemFont(ofSize: 16)
        return field
    }()
    
    var myDelegate:CreatePlanDetailController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        addSubview(bubble)
        bubble.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        bubble.addSubview(dollarSign)
        dollarSign.centerYAnchor.constraint(equalTo: bubble.centerYAnchor).isActive = true
        dollarSign.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        bubble.addSubview(moneyTextField)
        moneyTextField.widthAnchor.constraint(equalToConstant: 60).isActive = true
        moneyTextField.centerYAnchor.constraint(equalTo: bubble.centerYAnchor).isActive = true
        moneyTextField.leadingAnchor.constraint(equalTo: dollarSign.trailingAnchor, constant: 5).isActive = true
        moneyTextField.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
