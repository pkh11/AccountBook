//
//  SettingTableViewCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/15.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ settings: Settings) {
        title.text = settings.rightText
        
        if settings.hashValue == Settings.appVersion.hashValue {
            detail.isHidden = false
        } else {
            detail.isHidden = true
        }
    }
}

