//
//  SettingViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self

    }
}
extension SettingViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "데이터"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell else {
            return UITableViewCell()
        }
        let settings = Settings.allCases
        cell.updateUI(settings[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cases = Settings.allCases[indexPath.row]
        
        if cases == Settings.appVersion {
            
            guard let vc = self.storyboard?.instantiateViewController(identifier: "VersionDetailViewController") as? VersionDetailViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
            
        } else if cases == Settings.limit {
            
            let alertAction = UIAlertController(title: "알림", message: "예산을 변경하면 기존에 입력된 데이터는 지워집니다.", preferredStyle: .alert)
            alertAction.addTextField(configurationHandler: { myTextField in
                myTextField.placeholder = "예산을 입력해주세요."
            })
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let okButton = UIAlertAction(title: "변경", style: .default, handler: { _ in
                
                guard let account = alertAction.textFields?[0].text else { return }
    
                // update account
                UserDefaults.standard.setValue(account, forKey: "myAccount")
                
                // remove coredata
                Storage.shared.deleteData()
            })
            
            alertAction.addAction(cancelButton)
            alertAction.addAction(okButton)
            
            self.present(alertAction, animated: true, completion: nil)
        }
    }
}
