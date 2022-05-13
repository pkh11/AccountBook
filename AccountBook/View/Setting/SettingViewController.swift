//
//  SettingViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/10/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import GoogleMobileAds

class SettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    let actionViewModel = ActionViewModel()
    let settingViewModel = SettingViewModel()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let bannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureADBanner()
        bind(settingViewModel)
        attribute()
        layer()
    }
}

// MARK: Configure init
extension SettingViewController {
    private func configureADBanner() {
        bannerView.adUnitID = "ca-app-pub-2942820178759316/8451822973"
        // release ca-app-pub-2942820178759316/8451822973
        // test ca-app-pub-3940256099942544/2934735716
        
        bannerView.adUnitID = Constants.sharedInstance.admobUnitId
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func bind(_ viewModel: SettingViewModel) {
        // tableview cell data
        viewModel.settingDatas
            .drive(tableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: IndexPath(row: row, section: 0)) as! SettingTableViewCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.showDetail
            .emit(to: self.rx.showDetail)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        tableView.backgroundColor = .customGray3
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    private func layer() {
        [tableView, bannerView].forEach {
            view.addSubview($0)
        }
        
        bannerView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bannerView.snp.top)
        }
    }
}

extension SettingViewController: UITextFieldDelegate {
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
            }else{ // 숫자가 아닐 때
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 문자일 때
                    return false
                }
            }

        }
        
        return true
    }
}

// MARK: Reactive Extension
extension Reactive where Base: SettingViewController {
    var showDetail: Binder<Settings> {
        return Binder(base) { base, data in
            switch data{
            case .limit:
                let alertAction = UIAlertController(title: "알림", message: "예산을 변경하면 기존에 입력된 데이터는 지워집니다.", preferredStyle: .alert)
                alertAction.addTextField(configurationHandler: { myTextField in
                    myTextField.delegate = base
                    myTextField.placeholder = "예산을 입력해주세요.(최대 100만)"
                })
                let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                let okButton = UIAlertAction(title: "변경", style: .default, handler: { _ in
                    
                    guard let account = alertAction.textFields?[0].text?.replacingOccurrences(of: ",", with: "") else { return }
                    
                    if account.count > ActionViewModel.amountLimit {
                        let vc = TransientAlertViewController()
                        vc.titleMessage = "한도를 초과하였습니다.😀"
                        base.presentPanModal(vc)
                    } else {
                        // update account
                        UserDefaults.standard.setValue(Int(account), forKey: "myAccount")
                        
                        // remove coredata
                        Storage.shared.deleteData()
                        
                        let vc = TransientAlertViewController()
                        vc.titleMessage = "예산을 변경하였습니다.😀"
                        base.presentPanModal(vc)
                    }
                })
                
                alertAction.addAction(cancelButton)
                alertAction.addAction(okButton)
                
                base.present(alertAction, animated: true, completion: nil)
                break
            case .appVersion:
                let versionDetailViewController = VersionDetailViewController()
                base.navigationController?.pushViewController(versionDetailViewController, animated: true)
                break
            }
        }
    }
}
