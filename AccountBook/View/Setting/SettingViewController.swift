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
//        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
}
extension SettingViewController {
    
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
        } else {
           
        }
    }
}
