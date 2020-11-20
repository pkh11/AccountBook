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
    
//    private let noResultsLabel: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "No Results"
//        label.textAlignment = .center
//        label.textColor = .green
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        return label
//    }()
    
    @IBOutlet weak var tableView: UITableView!
    var storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        self.spinner.show(in: view)
        
        print("금액 : \(UserDefaults.standard.value(forKey: "myAccount"))")
        
        storage.loadFromData(completion: { success in
            if success {
                
            }
            self.spinner.dismiss()
        })
//        print("storage.deleteData : \(storage.deleteData())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("view willappear storage.loadFromData : \(storage.loadFromData())")
//        self.spinner.show(in: view)
//
//        storage.loadFromData(completion: { success in
//            if success {
//                self.tableView.reloadData()
//            }
//            self.spinner.dismiss()
//        })
        
        // 최대 예산 설정
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int else {
            return
        }
        headerView.maxBudget.text = String(myAccount.withComma)
    
        // 잔여 한도 설정
        
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
        
        if storage.transactions.isEmpty {
            return 1
        } else {
            let dataCount = storage.transactions.count
            return dataCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if storage.transactions.isEmpty {
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
            cell.updateUI(storage.transactions[indexPath.row])
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
