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
    var transactions: [Account] = []
    
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
        
        headerView.verticalSlider.slider.maximumValue = Float(myAccount)
        headerView.maxBudget.text = String(myAccount.withComma)
        headerView.warningAnimationView.play()
    }
    
    func fetchData() {
        self.spinner.show(in: view)
        storage.loadFromData(completion: { data in
            
            self.transactions = data
            let used = self.transactions.map{ Int($0.amount) }.reduce(0, { $0 + $1})
            print("\(used)")
            self.headerView.expenditureCost.text = "\(used.withComma) 원"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.5,
                               delay: 0.0,
                               options: .curveEaseInOut,
                               animations: { self.headerView.verticalSlider.slider.setValue(Float(used), animated: true) },
                               completion: nil)
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
            let remainCost = myAccount - self.transactions.map{ Int($0.amount) }.reduce(0, { $0 + $1})
            headerCell.updateUI(remainCost.withComma)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
