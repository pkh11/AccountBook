//
//  SpendTypeCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/10.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class SpendTypeCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ str: String) {
        typeLabel.text = str
        
        switch str {
        case "대중교통":
            iconImageView.image = UIImage(named: "bus")
        case "술자리":
            iconImageView.image = UIImage(named: "beer")
        case "물건구입":
            iconImageView.image = UIImage(named: "bag")
        case "커피":
            iconImageView.image = UIImage(named: "coffee")
        case "보험":
            iconImageView.image = UIImage(named: "insurance")
        default:
            iconImageView.image = UIImage(named: "bag")
        }
    }
}
