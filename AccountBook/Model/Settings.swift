//
//  Settings.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

enum Settings: CaseIterable {
    // allCases를 써서 numberOfRows를 잡아주세요.
    case limit
    case appVersion
    
    var rightText: String? {
        switch self {
        case .limit: return "예산"
        case .appVersion: return "버전 정보"
        }
    }
    
    var info: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return "\(version)"
    }
}

