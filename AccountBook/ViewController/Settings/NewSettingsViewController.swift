//
//  NewSettingsViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/13.
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
        $0.separatorStyle = .singleLine
        $0.separatorInset = .zero
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

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.topItem?.title = "설정"
       
        view.backgroundColor = .customGray1
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
                case .limit:
                    let alertAction = UIAlertController(title: "알림", message: "예산을 변경하면 기존에 입력된 데이터는 지워집니다.", preferredStyle: .alert)
                    alertAction.addTextField(configurationHandler: { myTextField in
                        myTextField.delegate = owner
                        myTextField.placeholder = "예산을 입력해주세요.(최대 100만)"
                    })
                    let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    let okButton = UIAlertAction(title: "변경", style: .default, handler: { _ in
                        
                        guard let account = alertAction.textFields?[0].text?.replacingOccurrences(of: ",", with: "") else { return }
                        
                        if account.count > NewWriteBudgetReactor.amountLimit {
                            let vc = TransientAlertViewController()
                            vc.titleMessage = "한도를 초과하였습니다.😀"
                            owner.presentPanModal(vc)
                        } else {
                            // update account
                            UserDefaults.standard.setValue(Int(account), forKey: "myAccount")
                            
                            // remove coredata
                            Storage.shared.deleteAllData()
                            
                            let vc = TransientAlertViewController()
                            vc.titleMessage = "예산을 변경하였습니다.😀"
                            owner.presentPanModal(vc)
                        }
                    })
                    
                    alertAction.addAction(cancelButton)
                    alertAction.addAction(okButton)
                    owner.present(alertAction, animated: true, completion: nil)
                    
                case .appVersion:
                    let versionDetailViewController = VersionDetailViewController()
                    owner.navigationController?.pushViewController(versionDetailViewController, animated: true)
                    
                }
            }
            .disposed(by: self.disposeBag)
    }
}

extension NewSettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            } else { // 숫자가 아닐 때
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                } else { // 문자일 때
                    return false
                }
            }

        }
        
        return true
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
