//
//  SettingViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let actionViewModel = ActionViewModel()
    let constants = Constants.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        bannerView.adUnitID = "ca-app-pub-2942820178759316/8451822973"
        // release ca-app-pub-2942820178759316/8451822973
        // test ca-app-pub-3940256099942544/2934735716
        
        bannerView.adUnitID = constants.admobUnitId
        bannerView.translatesAutoresizingMaskIntoConstraints = false        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "데이터"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell else {
            return UITableViewCell()
        }
        let settings = Settings.allCases
        cell.updateUI(settings[indexPath.row])
        
        return cell
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cases = Settings.allCases[indexPath.row]
        
        if cases == Settings.appVersion {
            
            guard let vc = self.storyboard?.instantiateViewController(identifier: "VersionDetailViewController") as? VersionDetailViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
            
        } else if cases == Settings.limit {
            
            let alertAction = UIAlertController(title: "알림", message: "예산을 변경하면 기존에 입력된 데이터는 지워집니다.", preferredStyle: .alert)
            alertAction.addTextField(configurationHandler: { myTextField in
                myTextField.delegate = self
                myTextField.placeholder = "예산을 입력해주세요.(최대 100만)"
            })
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let okButton = UIAlertAction(title: "변경", style: .default, handler: { _ in
                
                guard let account = alertAction.textFields?[0].text?.replacingOccurrences(of: ",", with: "") else { return }
                
                if account.count > self.actionViewModel.amountLimit {
                    let vc = TransientAlertViewController()
                    vc.titleMessage = "한도를 초과하였습니다.😀"
                    self.presentPanModal(vc)
                } else {
                    // update account
                    UserDefaults.standard.setValue(Int(account), forKey: "myAccount")
                    
                    // remove coredata
                    Storage.shared.deleteData()
                    
                    let vc = TransientAlertViewController()
                    vc.titleMessage = "예산을 변경하였습니다.😀"
                    self.presentPanModal(vc)
                }
            })
            
            alertAction.addAction(cancelButton)
            alertAction.addAction(okButton)
            
            self.present(alertAction, animated: true, completion: nil)
        }
    }
}

extension SettingViewController: UITextFieldDelegate {
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


