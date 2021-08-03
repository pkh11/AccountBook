//
//  ExpenditureTableHeaderViewCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/01.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import VerticalSlider
import Lottie


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
   
    @IBOutlet weak var verticalSlider: VerticalSlider!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var warningAnimationView: AnimationView! {
        didSet {
            warningAnimationView.contentMode = .scaleAspectFit
            warningAnimationView.loopMode = .loop
            warningAnimationView.animationSpeed = 0.5
        }
    }
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var costViewHeight: NSLayoutConstraint!
}
