//
//  HomeViewModel.swift
//  AccountBook
//
//  Created by 박균호 on 2021/01/12.
//  Copyright © 2021 FastCampus. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    var storage = Storage.shared
    
    func isEffectiveLimit() {
        
    }
    
    func limitCheck() -> Observable<String> {
        let mostUsedType = storage.trasactionDailyGroup.mostUsedType
        var warningText = ""
        
        if !mostUsedType.isEmpty {
            warningText = "가장 많이 사용한 유형은 '\(mostUsedType)' 입니다."
        }
        return Observable.just(warningText)
    }
}
