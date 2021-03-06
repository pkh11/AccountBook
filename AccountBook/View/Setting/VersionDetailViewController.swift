//
//  VersionDetailViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/16.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class VersionDetailViewController: UIViewController {

    @IBOutlet weak var appIconImage: UIImageView!
    @IBOutlet weak var versionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVersionInfo()
    }
    
    func setVersionInfo() {
        if let version = Settings.appVersion.info {
            versionText.text = "현재 버전은 \(version) 입니다."
        }
    }
}
