//
//  SpendTypeViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/10.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import PanModal

internal final class SpendTypeViewController: UIViewController, PanModalPresentable {

    @IBOutlet var tableView: UITableView!
    
    internal var selectedCompletion: ((SpendType) -> Void)?
    private var spendTypes: [SpendType] = SpendType.allCases
    
    // MARK: - Pan Modal Presentable

    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(350)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate, DataSource
extension SpendTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpendTypeTableViewCell", for: indexPath) as? SpendTypeCell
            else { return UITableViewCell() }

        cell.configure(spendTypes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCompletion?(spendTypes[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}


