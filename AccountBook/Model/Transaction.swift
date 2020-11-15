//
//  Transaction.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

enum SpendType: String {
    case 대중교통
    case 식사
    case 보험
    case 술자리
    case 물건구입
    case 커피
    case 기타
    
    var warning: String {
        switch self {
        case .대중교통: return "교통비 지출이 심해요."
        case .식사: return "밥을 너무 많이 먹었어요."
        case .보험: return "보험비가 너무 나와요."
        case .술자리:  return "술좀 그만 드세요."
        case .물건구입: return "과소비가 심해요."
        case .커피: return "커피좀 줄이세요."
        default: return "기타물건을 너무 많이사셨어요. 조심하세요."
        }
    }
}

struct Transaction {
    var amount: Float
    var date: Date
    var type: String
    var text: String
}
