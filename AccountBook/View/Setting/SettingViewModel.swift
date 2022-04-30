//
//  SettingViewModel.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2022/04/30.
//  Copyright © 2022 FastCampus. All rights reserved.
//

import RxSwift
import RxCocoa

struct SettingViewModel {
    // view -> viewModel
    let itemSelected = PublishRelay<Int>()
    
    // viewModel -> view
    let settingDatas: Driver<[Settings]>
    let showDetail: Signal<Settings>
    
    private let settings = PublishSubject<[Settings]>()
    
    init() {
        settingDatas = Observable.just(Settings.allCases)
            .asDriver(onErrorJustReturn: [])
            
        let selected = itemSelected
            .withLatestFrom(settingDatas) {
                $1[$0]
            }
        
        showDetail = selected
            .asSignal(onErrorSignalWith: .empty())
    }
}


