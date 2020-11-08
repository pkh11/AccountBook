//
//  HomeViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerView: UIView = {
        let nib = UINib(nibName: "ExpenditureTableHeaderView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }()
    
    var storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: lending data
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        
        print("storage.loadFromData : \(storage.loadFromData())")
//        print("storage.deleteData : \(storage.deleteData())")
    }
    override func viewWillAppear(_ animated: Bool) {
//        print("view willappear storage.loadFromData : \(storage.loadFromData())")
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = storage.transactions.count
        
        if dataCount == 0 {
            
        } else {
            
        }
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureTableViewCell") as? ExpenditureTableViewCell else {
            return UITableViewCell()
        }
        cell.updateUI(storage.transactions[indexPath.row])
        return cell
    }
}
