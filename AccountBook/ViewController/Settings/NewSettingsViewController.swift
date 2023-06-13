//
//  NewSettingsViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/13.
//  Copyright © 2023 FastCampus. All rights reserved.
//
import UIKit
import RxDataSources
import ReactorKit
import RxSwift
import RxCocoa

internal final class NewSettingsViewController: UIViewController, StoryboardView {
    // MARK: UI

    
    // MARK: - VARIABLES
    internal var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - SYSTEM FUNC
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Reactorkit
    func bind(reactor: NewSettingsReactor) {
        
    }
}

enum SettingsSectionModel {
    case settings
}

enum SettingsItem {
    case settings
}

extension SettingsSectionModel: SectionModelType {
    typealias Item = SettingsItem
    
    var items: [SettingsItem] {
        set {
            switch self {
            case .settings:
                self = .settings
            }
        }
//        get {
//            switch self {
//            case .settings:
//
//            }
//        }
    }
    
    init(original: SettingsSectionModel, items: [SettingsItem]) {
        switch original {
        case .settings:
            self = .settings
        }
    }
}
