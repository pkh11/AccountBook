//
//  ExpenditureTableViewCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/01.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class ExpenditureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var expenditureContents: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(_ spendInfo: SpendInfo) {
        cost.text = String("- \(spendInfo.amountFloatToInt) 원")
        expenditureContents.text = spendInfo.text
        date.text = spendInfo.date.toString()
    }
}

class ExpenditureTableHeaderCell: UITableViewCell {
    
    @IBOutlet weak var remainCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ account: String) {
        remainCost.text = "잔여한도: \(account)"
    }
}

class ExpenditureTableEmptyCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
