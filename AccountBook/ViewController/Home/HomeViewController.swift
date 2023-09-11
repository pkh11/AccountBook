//
//  HomeViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import JGProgressHUD
import RxSwift

class HomeViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    private let spinner = JGProgressHUD(style: .dark)
    var headerView: ExpenditureTableHeaderView = {
        let nib = UINib(nibName: "ExpenditureTableHeaderView", bundle: nil)
        return nib.instantiate(withOwner: HomeViewController.self, options: nil).first as! ExpenditureTableHeaderView
    }()
    
    let homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
        limitCheck()
        setHeaderView()
    }
    
    func setHeaderView() {
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int else {
            return
        }
        
        headerView.verticalSlider.slider.maximumValue = Float(myAccount)
        headerView.maxBudget.text = String(myAccount.withComma)
    }
    
    func limitCheck() {
        
        let mostUsedType = homeViewModel.isEffectiveLimit()
        
        mostUsedType.subscribe(onNext: { [weak self] type in
            guard let strongSelf = self else { return }
            if !type.isEmpty {
                strongSelf.headerView.warningView.isHidden = false
                strongSelf.headerView.warningAnimationView.play()
                strongSelf.headerView.warningText.text = "가장 많이 사용한 유형은 \n'\(type)' 입니다."
            } else {
                strongSelf.headerView.warningView.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    func fetchData() {
        self.spinner.show(in: view)
        
        homeViewModel.fetchDatas()
        homeViewModel.reloadTableViewClosure = { used in
            
            guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Float else {
                return
            }
            
            self.headerView.expenditureCost.text = "\(Int(used).withComma) 원"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.7,
                               delay: 0.0,
                               options: .curveEaseInOut,
                               animations: {
                                self.headerView.verticalSlider.slider.setValue(used, animated: true)
                                
                                if used != 0 {
                                    self.headerView.costViewHeight.constant = self.headerView.verticalSlider.bounds.height * CGFloat(used/myAccount) + 85 - 11
                                } else {
                                    self.headerView.costViewHeight.constant = 0
                                }
                                
                                self.headerView.layoutIfNeeded()
                                
                               },
                               completion: nil)
            }
        }
        self.spinner.dismiss()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureTableHeaderCell") as? ExpenditureTableHeaderCell else {
            return UITableViewCell()
        }
        
        let cost = homeViewModel.getRemainCost()
        headerCell.updateUI(cost.withComma)

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = homeViewModel.numberOfDatas()
        if count == 0 {
            return 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = homeViewModel.numberOfDatas()
        if count == 0 {
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
            
            let spendInfo = homeViewModel.getData(indexPath.row)
            cell.updateUI(spendInfo)
            
            return cell
        }
    }
}
