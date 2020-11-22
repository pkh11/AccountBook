//
//  AlertView.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/22.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import PanModal

class AlertViewController: UIViewController, PanModalPresentable {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedCompletion: ((String) -> Void)?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeModal(_ sender: Any) {
        selectedCompletion?("\(datePicker.date)")
        self.dismiss(animated: true, completion: nil)
    }
}
