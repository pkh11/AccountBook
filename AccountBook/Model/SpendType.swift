//
//  SpendType.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/13
//
        
import UIKit
import Foundation

enum SpendType: String, CaseIterable {
    case 대중교통
    case 식사
    case 보험
    case 술자리
    case 물건구입
    case 커피
    case 기타
    
    var labelMessage: String {
        return self.rawValue
    }
    
    var iconImg: UIImage? {
        switch self {
        case .대중교통: return "🚌".image()
        case .식사: return "🍚".image()
        case .술자리: return "🍻".image()
        case .물건구입: return "👜".image()
        case .커피: return "☕️".image()
        case .보험: return "🛡".image()
        default: return "🎁".image()
        }
    }
    
    var warningMessage: String {
        switch self {
            case .대중교통: return "교통비 지출이 심해요. 걸어다니세요.."
            case .식사: return "밥을 너무 많이 먹었어요. 다이어트 돌입!"
            case .보험: return "보험비가 너무 나와요."
            case .술자리:  return "술좀 그만 드세요. 간에 안좋아요.."
            case .물건구입: return "과소비가 심해요."
            case .커피: return "커피좀 줄이세요. 카페인 중독!"
            default: return "기타물건을 너무 많이 사셨어요. 조심하세요."
        }
    }
}
