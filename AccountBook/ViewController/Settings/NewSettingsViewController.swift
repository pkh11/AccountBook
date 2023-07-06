//
//  NewSettingsViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/13.
//  Copyright © 2023 FastCampus. All rights reserved.
//
import UIKit
import SnapKit
import Then
import RxDataSources
import ReactorKit
import RxSwift
import RxCocoa
import ReusableKit

internal final class NewSettingsViewController: UIViewController, StoryboardView {
    typealias DataSource = RxTableViewSectionedReloadDataSource<SettingsSectionModel>
    
    // MARK: - UI
    private enum Reusable {
        static let budgetTableViewCell = ReusableCell<BudgetTableViewCell>()
        static let versionInfoTableViewCell = ReusableCell<VersionInfoTableViewCell>()
    }
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.register(Reusable.budgetTableViewCell)
        $0.register(Reusable.versionInfoTableViewCell)
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private var dataSource = DataSource(configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .budget(reactor: let reactor):
            let cell = tableView.dequeue(Reusable.budgetTableViewCell, for: indexPath)
            cell.bind(reactor: reactor)
            return cell
            
        case .versionInfo(reactor: let reactor):
            let cell = tableView.dequeue(Reusable.versionInfoTableViewCell, for: indexPath)
            cell.bind(reactor: reactor)
            return cell
        }
    })
    
    // MARK: - VARIABLES
    internal var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - SYSTEM FUNC
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Reactorkit
    func bind(reactor: NewSettingsReactor) {
        Observable.just(NewSettingsReactor.Action.loadSettingsItems)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self) { owner, indexPath in
                let item = Settings.allCases[indexPath.row]
                
                switch item {
                case .limit: break
                    
                case .appVersion:
                    let versionDetailViewController = VersionDetailViewController()
                    self.navigationController?.pushViewController(versionDetailViewController, animated: true)
                    
                }
            }
            .disposed(by: self.disposeBag)
    }
}

enum SettingsSectionModel {
    case settings(items: [SettingsItem])
}

enum SettingsItem {
    case budget(reactor: BudgetCellReactor)
    case versionInfo(reactor: VersionInfoCellReactor)
}

extension SettingsSectionModel: SectionModelType {
    typealias Item = SettingsItem
    
    var items: [SettingsItem] {
        set {
            switch self {
            case .settings(items: _):
                self = .settings(items: newValue)
            }
        }
        get {
            switch self {
            case .settings(items: let items):
                return items.map { $0 }
            }
        }
    }
    
    init(original: SettingsSectionModel, items: [SettingsItem]) {
        switch original {
        case .settings(items: _):
            self = .settings(items: items)
        }
    }
}
