//
//  SpendTypeViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/10.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import PanModal

class SpendTypeViewController: UIViewController, PanModalPresentable {

    @IBOutlet var tableView: UITableView!
    
    var isShortFormEnabled = true
    
    // MARK: - Pan Modal Presentable

    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    let types: [String] = ["\(SpendType.대중교통)", "\(SpendType.물건구입)", "\(SpendType.보험)", "\(SpendType.술자리)", "\(SpendType.물건구입)", "\(SpendType.커피)", "\(SpendType.기타)"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}
extension SpendTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpendTypeTableViewCell", for: indexPath) as? SpendTypeCell
            else { return UITableViewCell() }

        cell.updateUI(types[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected : \(types[indexPath.row])")
    }
}


