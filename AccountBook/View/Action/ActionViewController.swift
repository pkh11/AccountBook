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
import PanModal

class ActionViewController: UIViewController {

    var storage = Storage.shared
    @IBOutlet weak var spendTypeLabel: UILabel!
    @IBOutlet weak var amountOfMoney: UITextField!
    @IBOutlet weak var memo: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountOfMoney.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openModal))
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        spendTypeLabel.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(dismissKeyboardRecognizer)
//        amountOfMoney.addGestureRecognizer(dismissKeyboardRecognizer)
//        memo.addGestureRecognizer(dismissKeyboardRecognizer)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func openModal(sender: UITapGestureRecognizer) {
        guard let storyboard = UIStoryboard(name: "SpendType", bundle: nil).instantiateViewController(identifier: "SpendTypeViewController") as? SpendTypeViewController else {
            return
        }
        presentPanModal(storyboard)
        
        storyboard.selectedCompletion = { type in
            self.spendTypeLabel.text = type.rawValue
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        
        guard let money = amountOfMoney.text?.replacingOccurrences(of: ",", with: ""), let memo = memo.text else {
            return
        }
        
        if money.isEmpty || memo.isEmpty {
            print("필수값 입력")
            return
        }
        
        if let amount = Float(money) {
            storage.saveData(amount, spendTypeLabel.text ?? "", memo, completion: { success in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("입력 오류")
                }
            })
        }
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
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
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
