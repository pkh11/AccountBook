//
//  SpendTypeCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/10.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class SpendTypeCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ str: String) {
        typeLabel.text = str
    }
}
