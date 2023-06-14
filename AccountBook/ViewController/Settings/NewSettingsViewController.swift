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
    
    // MARK: UI
    private enum Reusable {
        static let newSettingsTableViewCell = ReusableCell<NewSettingsTableViewCell>()
    }
    
    private var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.register(Reusable.newSettingsTableViewCell)
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: - VARIABLES
    internal var disposeBag: DisposeBag = DisposeBag()
    
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
    }
    
    // MARK: Reactorkit
    func bind(reactor: NewSettingsReactor) {
        
    }
}

enum SettingsSectionModel {
    case settings(items: [SettingsItem])
}

enum SettingsItem {
    case settings(reactor: NewSettingsCellReactor)
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
