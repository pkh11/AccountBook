//
//  SettingTableViewCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/15.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ settings: Settings) {
        titleLabel.text = settings.titleText
    }
    
    private func attribute() {
        backgroundColor = .white
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(18)
        }
    }
}

