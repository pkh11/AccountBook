//
//  ExpenditureTableHeaderViewCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/01.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class ExpenditureTableHeaderView: UIView {

    @IBOutlet weak var expenditureCost: UILabel! {
        didSet {
            let total = Storage.shared.trasactionDailyGroup.totalToInt.withComma
            expenditureCost.text = "\(total) 원"
        }
    }
    
    @IBOutlet weak var maxBudget: UILabel! {
        didSet {
            if let account = UserDefaults.standard.value(forKey: "myAccount") as? String {
                maxBudget.text = account
            }
        }
    }
    
    @IBOutlet weak var minBudget: UILabel! {
        didSet {
            minBudget.text = "0"
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }
    }
    
    @IBAction func changeValue(_ sender: Any) {
        print("\(slider.value)")
    }
}
