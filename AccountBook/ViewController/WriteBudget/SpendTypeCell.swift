//
//  SpendTypeCell.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/10.
//

import UIKit
import SnapKit
import Then

internal final class SpendTypeCell: UITableViewCell {
    
    // MARK: - UI
    private let totalView = UIView()
    private let iconImgView = UIImageView()
    private let typeLbl = UILabel().then {
        $0.tintColor = UIColor(red: 185, green: 185, blue: 187, alpha: 1.0)
    }
    
    // MARK: - SYSTEM FUNC
    override func awakeFromNib() {
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func makeUI() {
        addSubview(totalView)
        totalView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        totalView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        totalView.addSubview(typeLbl)
        typeLbl.snp.makeConstraints {
            $0.leading.equalTo(iconImgView.snp.trailing).offset(15)
            $0.centerY.equalTo(iconImgView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }
    
    internal func configure(_ type: SpendType) {
        typeLbl.text = type.labelMessage
        iconImgView.image = type.iconImg
    }
}
