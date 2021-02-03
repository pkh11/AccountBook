//
//  ActionViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PanModal

class ActionViewController: UIViewController {

    @IBOutlet weak var spendTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountOfMoney: UITextField!
    @IBOutlet weak var memo: UITextField!
    @IBOutlet weak var amountOfMoneySelected: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    let disposeBag = DisposeBag()
    let actionViewModel = ActionViewModel()
    var storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        tabGestureBinding()
    }
    
    func bindUI() {
        
        amountOfMoney.placeholder = "금액을 입력하세요."
        amountOfMoney.rx.text.orEmpty.bind(to: actionViewModel.account).disposed(by: disposeBag)
        memo.rx.text.orEmpty.filter({ $0.count <= 10 }).bind(to: actionViewModel.memo).disposed(by: disposeBag)
        
        // 금액 입력 validation check in UI
        amountOfMoney.rx.text.orEmpty.subscribe(onNext: { account in
            let string = account.replacingOccurrences(of: ",", with: "")
            
            if string.count >= self.actionViewModel.amountLimit || string.isEmpty {
                self.amountOfMoneySelected.isHidden = true
            } else if string.count < self.actionViewModel.amountLimit {
                self.amountOfMoneySelected.isHidden = false
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            if let formattedNumber = formatter.number(from: string) {
                if let formattedString = formatter.string(from: formattedNumber) {
                    self.amountOfMoney.text = formattedString
                }
            }
            
        }).disposed(by: disposeBag)
        
        // 메모 입력 validation check in UI
        memo.rx.text.orEmpty.scan("", accumulator: { (previous, new) -> String in
            
            // saveButton height - keyboard height
            self.saveButton.frame.origin.y -= 100
            
            let memoLimit = self.actionViewModel.memoLimit
            
            if new.count > memoLimit {
                return previous ?? String(new.prefix(memoLimit))
            } else {
                return new
            }

        }).subscribe(memo.rx.text).disposed(by: disposeBag)
        
        
        // input validation
        actionViewModel.isValidate().subscribe(onNext: { result in
            self.saveButton.isEnabled = result
            if result {
                self.saveButton.backgroundColor = .customBlue1
            } else {
                self.saveButton.backgroundColor = .customGray1
            }
        }).disposed(by: disposeBag)
        
        // 저장버튼 클릭
        saveButton.rx.tap.do(onNext: { [unowned self] _ in
            self.amountOfMoney.resignFirstResponder()
            self.memo.resignFirstResponder()
        }).subscribe(onNext: {
            if self.actionViewModel.checkMyAccount() {
                if self.actionViewModel.saveData() {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error")
                }
            } else {
                let vc = TransientAlertViewController()
                vc.titleMessage = "예산을 설정해주세요.😀"
                self.presentPanModal(vc)
            }
        }).disposed(by: disposeBag)
    }
    
    func tabGestureBinding() {
        // tapGesuter binding
        view.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        spendTypeLabel.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            guard let storyboard = UIStoryboard(name: "SpendType", bundle: nil).instantiateViewController(identifier: "SpendTypeViewController") as? SpendTypeViewController else {
                return
            }
            strongSelf.presentPanModal(storyboard)
            
            storyboard.selectedCompletion = { type in
                strongSelf.spendTypeLabel.text = type.rawValue
                strongSelf.spendTypeLabel.textColor = .customBlack
                strongSelf.actionViewModel.type.accept(type.rawValue)
            }
        }).disposed(by: disposeBag)
        
        dateLabel.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            guard let storyboard = UIStoryboard(name: "DatePickerView", bundle: nil).instantiateViewController(identifier: "DatePickerViewController") as? DatePickerViewController else {
                return
            }
            
            strongSelf.presentPanModal(storyboard)
            
            storyboard.selectedCompletion = { time in
            
                let times = time.split(separator: " ")
                let dates = times[0]
                
                strongSelf.dateLabel.text = String(dates)
                strongSelf.dateLabel.textColor = .customBlack
                strongSelf.actionViewModel.date.accept(String(dates))
            }
            
        }).disposed(by: disposeBag)
    }

    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ActionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}

extension ActionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        amountOfMoneySelected.isHidden = false
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString),
                   let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString),
                       let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 문자일 때
                    return false
                }
            }
        }
        return true
    }
}
