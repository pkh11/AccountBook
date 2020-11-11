//
//  ActionViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import PanModal

class ActionViewController: UIViewController {

    var storage = Storage.shared
    @IBOutlet weak var spendTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage.saveData()
        // TODO: add transaction
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        storage.saveData()
        
    }
    @IBAction func openModal(_ sender: Any) {
        guard let storyboard = UIStoryboard(name: "SpendType", bundle: nil).instantiateViewController(identifier: "SpendTypeViewController") as? SpendTypeViewController else {
            return
        }
        presentPanModal(storyboard)
    }
}

extension ActionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}


