//
// Created by Jonathan Dowdell on 9/14/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import UIKit

class CustomNavController : UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
