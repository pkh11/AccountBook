//
//  NewSettingsTableViewCell.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/13.
//  Copyright © 2023 FastCampus. All rights reserved.
//

import UIKit
import RxSwift

internal final class NewSettingsTableViewCell: UITableViewCell {
    
    // MARK: VARIABLES
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: SYSTEM FUNC
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func makeUI() {
        
    }
}
