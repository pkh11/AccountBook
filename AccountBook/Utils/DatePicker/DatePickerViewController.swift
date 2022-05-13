//
//  AlertView.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/22.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import PanModal

class DatePickerViewController: UIViewController, PanModalPresentable {
    
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
        
        datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    @objc func changed(){
        let selectedDate = datePicker.date
        let now = Date()
        
        if selectedDate > now {
            datePicker.date = now
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        let datePickerDate = "\(datePicker.date)"
        let times = datePickerDate.split(separator: " ")
        let date = times[0]
        
        selectedCompletion?("\(date)")
        self.dismiss(animated: true, completion: nil)
    }
}
