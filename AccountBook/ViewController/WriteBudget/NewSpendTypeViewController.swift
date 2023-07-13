//
//  SpendTypeViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/13
//
        
import UIKit
import SnapKit
import Then
import PanModal
import ReusableKit

internal final class NewSpendTypeViewController: UIViewController, PanModalPresentable {
    
    
    private enum Reusable {
        static let spendTypeCell = ReusableCell<SpendTypeCell>()
    }
    
    // MARK: - UI
    private var tableView = UITableView().then {
        $0.register(Reusable.spendTypeCell)
    }
    
    // MARK: - VARIABLES
    private var spendTypes: [SpendType] = SpendType.allCases
    internal var selectedCompletion: ((SpendType) -> Void)?
    
    // MARK: - Pan Modal Presentable
    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(350)
    }
    
    // MARK: - SYSTEM FUNC
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate, DataSource
extension NewSpendTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(Reusable.spendTypeCell) else { return UITableViewCell() }
        cell.configure(spendTypes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCompletion?(spendTypes[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
