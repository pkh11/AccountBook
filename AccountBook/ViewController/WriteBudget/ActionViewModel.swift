//
//  ActionViewModel.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/30.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ActionViewModel {
    
    static let amountLimit = 7
    static let memoLimit = 10
    
    var storage = Storage.shared
    
    // View -> ViewModel
    var account = BehaviorRelay(value: "")
    var account2 = PublishRelay<String>()
    var date = BehaviorRelay(value: "")
    var date2 = PublishRelay<String>()
    var type = BehaviorRelay(value: "")
    var type2 = PublishRelay<String>()
    var memo = BehaviorRelay(value: "")
    let memo2 = PublishRelay<String>()
    
    // ViewModel -> View
    var isValidate: Driver<Bool>
    var keyboardHeight: Driver<CGFloat>
    
    init() {
        let consumptionAmount = account2
            .map {
                $0.replacingOccurrences(of: ",", with: "")
            }
        
        let isValidateAmount = consumptionAmount
            .map {
                !$0.isEmpty
            }.startWith(false)
        
        // "2022-05-10 14:09:56 +0000"
        let consumptionDate = date2
        let isValidateDate = consumptionDate
            .map {
                !$0.isEmpty
            }.startWith(false)
        let consumptionType = type2
        let isValidateType = consumptionType
            .map {
                !$0.isEmpty
            }.startWith(false)
        let consumptionMemo = memo2
        let isValidateMemo = consumptionMemo
            .map {
                $0.count < ActionViewModel.memoLimit && !$0.isEmpty
            }.startWith(false)
        
        isValidate = Observable.combineLatest(
            isValidateAmount,
            isValidateDate,
            isValidateType,
            isValidateMemo
        ).map {
            $0.0 && $0.1 && $0.2 && $0.3
        }.asDriver(onErrorJustReturn: false)
        
        keyboardHeight = Observable.from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> CGFloat in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGFloat in
                    0
                }
        ]).merge().asDriver(onErrorDriveWith: .empty())
    }
    
    func checkMyAccount() -> Bool {
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int, myAccount != 0 else {
            return false
        }
        return true
    }
    
    func saveData() -> String {
        var resultMessage = ""
        
        let accountToReplacing = account.value.replacingOccurrences(of: ",", with: "")
        guard let amount = Float(accountToReplacing) else {
            return ""
        }
        let memoValue = memo.value
        let typeValue = type.value
        let dateValue = date.value
    
        storage.saveData(amount, dateValue.toDate(dateValue), typeValue, memoValue, completion: { resultType in
            switch resultType {
            case .success(let _):
                resultMessage = "Success"
            case .failure(let error):
                
                guard let _error = error as? StorageErrors else { return }
                
                if _error == StorageErrors.failedSaveData {
                    resultMessage = "\(StorageErrors.failedSaveData)"
                } else if _error == StorageErrors.overAccount {
                    resultMessage = "\(StorageErrors.overAccount)"
                }
            }
        })
        return resultMessage
    }
}
