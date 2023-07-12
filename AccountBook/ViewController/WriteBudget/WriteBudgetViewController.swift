//
//  WriteBudgetViewController.swift
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

class WriteBudgetViewController: UIViewController {
    
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
        
        bindUI(actionViewModel)
        tabGestureBinding()
    }
    
    func bindUI(_ viewModel: ActionViewModel) {
        
        amountOfMoney.rx.text
            .orEmpty
            .bind(to: viewModel.account2)
            .disposed(by: disposeBag)
        
        memo.rx.text
            .orEmpty
            .filter({ $0.count <= ActionViewModel.memoLimit })
            .bind(to: viewModel.memo2)
            .disposed(by: disposeBag)
        
        // account bind
        amountOfMoney.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] string in
                let replacing = string.replacingOccurrences(of: ",", with: "")
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = Locale.current
                formatter.maximumFractionDigits = 0
                
                if let formattedNumber = formatter.number(from: replacing),
                   let formattedString = formatter.string(from: formattedNumber) {
                    self?.amountOfMoney.text = formattedString
                }
            }).disposed(by: disposeBag)
        
        // memo bind
        memo.rx.text
            .orEmpty
            .scan("", accumulator: { (previous, new) -> String in
                let memoLimit = ActionViewModel.memoLimit
                
                if new.count > memoLimit {
                    return previous ?? String(new.prefix(memoLimit))
                } else {
                    return new
                }
            })
            .subscribe(memo.rx.text)
            .disposed(by: disposeBag)
        
        // type bind
        viewModel.type2
            .bind(to: self.spendTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // date bind
        viewModel.date2
            .bind(to: self.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // button bind
        viewModel.isValidate
            .drive(self.rx.isValid)
            .disposed(by: disposeBag)
        
        viewModel.keyboardHeight
            .drive(onNext: { [weak self] height in
                guard let strongSelf = self else { return }
                if height > 0 {
                    strongSelf.bottomConstraint.constant = height - strongSelf.view.safeAreaInsets.bottom + 8
                    strongSelf.scrollView.contentInset.bottom = height / 2
                } else if height == 0 {
                    strongSelf.bottomConstraint.constant = height + 8
                    strongSelf.scrollView.contentInset = UIEdgeInsets.zero
                }
    
                UIView.animate(withDuration: 0.5) {
                    strongSelf.view.layoutIfNeeded()
                }
        }).disposed(by: disposeBag)
            
        
        // 저장버튼 클릭
        saveButton.rx.tap.do(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.amountOfMoney.resignFirstResponder()
            strongSelf.memo.resignFirstResponder()
        }).subscribe(onNext: {
            let vc = TransientAlertViewController()
            
            if viewModel.checkMyAccount() {
                
                let message = viewModel.saveData()
                
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
                strongSelf.actionViewModel.type2.accept(type.rawValue)
            }
        }).disposed(by: disposeBag)
        
        dateLabel.rx.tapGesture().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            guard let storyboard = UIStoryboard(name: "DatePickerView", bundle: nil).instantiateViewController(identifier: "DatePickerViewController") as? DatePickerViewController else {
                return
            }
            
            strongSelf.presentPanModal(storyboard)
            storyboard.selectedCompletion = { time in
                strongSelf.actionViewModel.date2.accept(time)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WriteBudgetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}

extension Reactive where Base: WriteBudgetViewController {
    var isValid: Binder<Bool> {
        return Binder(base) { base, valid in
            base.saveButton.isEnabled = valid
            if valid {
                base.saveButton.backgroundColor = .customBlue1
            } else {
                base.saveButton.backgroundColor = .customGray1
            }
        }
    }
}
