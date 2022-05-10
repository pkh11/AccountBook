//
//  VersionDetailViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/16.
//

import UIKit
import SnapKit

class VersionDetailViewController: UIViewController {
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private var versionLabel: UILabel = {
        let label = UILabel()
        if let version = Settings.appVersion.info {
            label.text = "현재 버전은 \(version) 입니다."
        }
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    private func layout() {
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
