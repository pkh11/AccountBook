//
//  ActionViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {

    var storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage.saveData()
        // TODO: add transaction
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        storage.saveData()
    }
}
