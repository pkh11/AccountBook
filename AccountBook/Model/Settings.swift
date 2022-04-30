//
//  Settings.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//

import Foundation

enum Settings: CaseIterable {
    case limit
    case appVersion
    
    var titleText: String? {
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

