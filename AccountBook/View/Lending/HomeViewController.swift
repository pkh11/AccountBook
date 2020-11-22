//
//  HomeViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import JGProgressHUD


class HomeViewController: UIViewController {
   
    private let spinner = JGProgressHUD(style: .dark)
    
    var headerView: ExpenditureTableHeaderView = {
        let nib = UINib(nibName: "ExpenditureTableHeaderView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! ExpenditureTableHeaderView
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var storage = Storage.shared
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        transactions = storage.transactions
//        print("storage.deleteData : \(storage.deleteData())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        // 최대 예산 설정
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int else {
            return
        }
        headerView.maxBudget.text = String(myAccount.withComma)

        // 잔여 한도 설정
    }
    
    func fetchData() {
        self.spinner.show(in: view)
        storage.loadFromData(completion: { success in
            if success {
                self.tableView.reloadData()
            }
            self.spinner.dismiss()
        })
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureTableHeaderCell") as? ExpenditureTableHeaderCell else {
            return UITableViewCell()
        }
        
        if let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int {
            headerCell.updateUI(myAccount.withComma)
        }

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if transactions.isEmpty {
            return 1
        } else {
            let dataCount = transactions.count
            return dataCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if transactions.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureTableEmptyCell") as? ExpenditureTableEmptyCell else {
                return UITableViewCell()
            }
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureTableViewCell") as? ExpenditureTableViewCell else {
                return UITableViewCell()
            }
            cell.updateUI(transactions[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
