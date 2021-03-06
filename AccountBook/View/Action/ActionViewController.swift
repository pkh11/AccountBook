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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    let actionViewModel = ActionViewModel()
    var storage = Storage.shared
    var isKeyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        tabGestureBinding()
    }
    
    func bindUI() {
    
        amountOfMoney.rx.text.orEmpty.bind(to: actionViewModel.account).disposed(by: disposeBag)
        memo.rx.text.orEmpty.filter({ $0.count <= 10 }).bind(to: actionViewModel.memo).disposed(by: disposeBag)
        
        // 금액 입력 validation check in UI
        amountOfMoney.rx.text.orEmpty.subscribe(onNext: { [weak self] account in
            guard let strongSelf = self else { return }
            let string = account.replacingOccurrences(of: ",", with: "")
            
            if string.count >= strongSelf.actionViewModel.amountLimit || string.isEmpty {
                strongSelf.amountOfMoneySelected.isHidden = true
            } else if string.count < strongSelf.actionViewModel.amountLimit {
                strongSelf.amountOfMoneySelected.isHidden = false
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            if let formattedNumber = formatter.number(from: string) {
                if let formattedString = formatter.string(from: formattedNumber) {
                    strongSelf.amountOfMoney.text = formattedString
                }
            }
            
        }).disposed(by: disposeBag)
        
        // 메모 입력 validation check in UI
        memo.rx.text.orEmpty.scan("", accumulator: { (previous, new) -> String in
            let memoLimit = self.actionViewModel.memoLimit
            
            if new.count > memoLimit {
                return previous ?? String(new.prefix(memoLimit))
            } else {
                return new
            }
        }).subscribe(memo.rx.text).disposed(by: disposeBag)
        
        // input validation
        actionViewModel.isValidate().subscribe(onNext: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            strongSelf.saveButton.isEnabled = result
            if result {
                strongSelf.saveButton.backgroundColor = .customBlue1
            } else {
                strongSelf.saveButton.backgroundColor = .customGray1
            }
        }).disposed(by: disposeBag)
        
        // 저장버튼 클릭
        saveButton.rx.tap.do(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.amountOfMoney.resignFirstResponder()
            strongSelf.memo.resignFirstResponder()
        }).subscribe(onNext: {
            let vc = TransientAlertViewController()
            
            if self.actionViewModel.checkMyAccount() {
                
                let message = self.actionViewModel.saveData()
                
                if message == "Success" {
                    self.dismiss(animated: true, completion: nil)
                } else if message == "\(StorageErrors.overAccount)"{
                    vc.titleMessage = "예산을 초과했습니다.😀"
                } else {
                    vc.titleMessage = "오류가 발생했습니다.😀"
                }
                
            } else {
                vc.titleMessage = "예산을 설정해주세요.😀"
            }
            self.presentPanModal(vc)
        }).disposed(by: disposeBag)
        
        _ = keyboardHeight().observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] keyboardHeight in
            guard let strongSelf = self else { return }
            if keyboardHeight > 0 {
                strongSelf.bottomConstraint.constant = keyboardHeight - strongSelf.view.safeAreaInsets.bottom + 8
                strongSelf.scrollView.contentInset.bottom = keyboardHeight / 2
            } else if keyboardHeight == 0 {
                strongSelf.bottomConstraint.constant = keyboardHeight + 8
                strongSelf.scrollView.contentInset = UIEdgeInsets.zero
            }
            
            UIView.animate(withDuration: 0.5) {
                strongSelf.view.layoutIfNeeded()
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
        
        memo.rx.tapGesture().subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
    }
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                    },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                    }
            ])
            .merge()
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
