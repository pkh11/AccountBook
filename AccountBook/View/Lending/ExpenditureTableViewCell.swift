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
    
    func updateUI(_ transaction: Transaction?) {
        if let _transaction = transaction {
            cost.text = String("-\(_transaction.amount)")
            expenditureContents.text = _transaction.text
            date.text = _transaction.date.toString()
        }
    }
}
