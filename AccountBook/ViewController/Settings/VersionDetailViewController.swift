//
//  VersionDetailViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/12
//

import UIKit
import SnapKit
import Then

internal final class VersionDetailViewController: UIViewController {
    
    // MARK: - UI
    private var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "appIcon")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private var versionLabel = UILabel().then {
        $0.text = "현재 버전은 \(Settings.appVersion.info ?? "") 입니다."
    }
    
    // MARK: - SYSTEM FUNC  
    override func loadView() {
        super.loadView()
        title = "버전 정보"
        view.backgroundColor = .white
        
        [iconImageView, versionLabel].forEach {
            view.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(90)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-140)
        }
        
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).offset(40)
        }
    }
}
