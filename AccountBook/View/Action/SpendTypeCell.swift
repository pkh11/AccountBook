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
        self.typeLabel.tintColor = UIColor(red: 185, green: 185, blue: 187, alpha: 1.0)
    }
    
    func updateUI(_ str: String) {
        typeLabel.text = str
        
        switch str {
        case "대중교통":
            iconImageView.image = "🚌".image()
        case "술자리":
            iconImageView.image = "🍻".image()
        case "물건구입":
            iconImageView.image = "👜".image()
        case "커피":
            iconImageView.image = "☕️".image()
        case "보험":
            iconImageView.image = "🛡".image()
        default:
            iconImageView.image = "🎁".image()
        }
    }
}
