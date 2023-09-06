//
//  NewWriteBudgetViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/09/04
//
        

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then
import PanModal
import JGProgressHUD

internal final class NewWriteBudgetViewController: UIViewController, StoryboardView {
    
    private lazy var totalView = UIView().then {
        $0.backgroundColor = .white
    }
    private lazy var totalScrollView = UIScrollView()
    private lazy var closeBtn = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.customBlue1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    }
    private lazy var questionTextLbl = UILabel().then {
        $0.text = "또 어디에\n쓰셨어요?"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
        $0.textColor = .black
    }
    
    private lazy var scrollContentsView = UIView().then {
        $0.backgroundColor = .clear
    }
    private lazy var contentsView = UIView()
    private lazy var contentsViewBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: 금액 입력 뷰
    private lazy var amountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private lazy var amountTotalView = UIView()
    
    private lazy var amountTextField = UITextField().then {
        $0.placeholder = "금액을 입력하세요. (최대 100만)"
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .right
        $0.keyboardType = .numberPad
    }
    
    private lazy var amountSelectedView = UIImageView().then {
        $0.image = UIImage(named: "selectedBox")
        $0.contentMode = .scaleToFill
    }
    
    private lazy var unitTextLbl = UILabel().then {
        $0.text = "원"
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .customBlack
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: 날짜 입력 뷰
    private lazy var dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 40
    }
    private lazy var dateTotalView = UIView()
    private lazy var dateSelectView = UIImageView().then {
        $0.image = UIImage(named: "selectbox")
        $0.contentMode = .scaleToFill
    }
    
    private lazy var dateTitleLbl = UILabel().then {
        $0.text = "날짜"
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .customGray2
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var dateTextLbl = UILabel().then {
        $0.text = ""
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
    
    private lazy var dateTextPlaceHolder = UILabel().then {
        $0.text = "날짜를 입력해주세요."
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
        
    private lazy var dateBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    
    // MARK: 분류 타입 뷰
    private lazy var typeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 40
    }
    private lazy var typeTotalView = UIView()
    private lazy var typeSelectView = UIImageView().then {
        $0.image = UIImage(named: "selectbox")
        $0.contentMode = .scaleToFill
    }
    
    private lazy var typeTitleLbl = UILabel().then {
        $0.text = "분류"
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .customGray2
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var typeTextLbl = UILabel().then {
        $0.text = ""
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
    
    private lazy var typeTextPlaceHolder = UILabel().then {
        $0.text = "분류를 선택해주세요."
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
    
    private lazy var typeBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: 메모 입력 뷰
    private lazy var memoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 40
    }
    private lazy var memoTotalView = UIView()
    private lazy var memoSelectView = UIImageView().then {
        $0.image = UIImage(named: "selectbox_empty")
        $0.contentMode = .scaleToFill
    }
    
    private lazy var memoTitleLbl = UILabel().then {
        $0.text = "메모"
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .customGray2
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var memoPlaceholderLbl = UILabel().then {
        $0.text = "메모를 입력하세요.(최대10자)"
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
    
    private lazy var memoTextLbl = UITextField().then {
        $0.textColor = .customGray1
        $0.font = .systemFont(ofSize: 17)
    }
    
    // MARK: 저장 버튼
    private lazy var saveBtn = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.tintColor = .white
        $0.backgroundColor = .customBlue1
        $0.layer.cornerRadius = 12
        $0.layer.cornerCurve = .circular
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    // MARK: - VARIABLES
    internal var disposeBag: DisposeBag = DisposeBag()
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - SYSTEM FUNC
    deinit {
        print("deinit")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        view.addSubview(totalView)
        totalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        totalView.addSubview(totalScrollView)
        totalScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        totalScrollView.addSubview(scrollContentsView)
        scrollContentsView.snp.makeConstraints {
            $0.width.equalTo(totalScrollView.snp.width)
            $0.height.equalTo(totalScrollView.snp.height)
        }
        
        scrollContentsView.addSubview(questionTextLbl)
        questionTextLbl.snp.makeConstraints {
            $0.top.equalTo(36)
            $0.leading.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        scrollContentsView.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.top.equalTo(questionTextLbl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentsView.addSubview(contentsViewBtn)
        contentsViewBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 금액 입력 뷰
        amountTotalView.addSubview(amountTextField)
        amountTextField.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        amountTotalView.addSubview(amountSelectedView)
        amountSelectedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        amountStackView.addArrangedSubview(amountTotalView)
        amountStackView.addArrangedSubview(unitTextLbl)
        
        contentsView.addSubview(amountStackView)
        amountStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        let lineView1 = UIView().then { $0.backgroundColor = .customGray3 }
        contentsView.addSubview(lineView1)
        lineView1.snp.makeConstraints {
            $0.top.equalTo(amountStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
        }
        
        // 날짜 입력 뷰
        dateTotalView.addSubview(dateTextLbl)
        dateTextLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        dateTextLbl.addSubview(dateTextPlaceHolder)
        dateTextPlaceHolder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateTotalView.addSubview(dateSelectView)
        dateSelectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateTotalView.addSubview(dateBtn)
        dateBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateStackView.addArrangedSubview(dateTitleLbl)
        dateStackView.addArrangedSubview(dateTotalView)
        
        dateTitleLbl.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        
        contentsView.addSubview(dateStackView)
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        let lineView2 = UIView().then { $0.backgroundColor = .customGray3 }
        contentsView.addSubview(lineView2)
        lineView2.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
        }
        
        // 분류 타입 뷰
        typeTotalView.addSubview(typeTextLbl)
        typeTextLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        typeTextLbl.addSubview(typeTextPlaceHolder)
        typeTextPlaceHolder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeTotalView.addSubview(typeSelectView)
        typeSelectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeTotalView.addSubview(typeBtn)
        typeBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeStackView.addArrangedSubview(typeTitleLbl)
        typeStackView.addArrangedSubview(typeTotalView)
        
        typeTitleLbl.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        
        contentsView.addSubview(typeStackView)
        typeStackView.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        let lineView3 = UIView().then { $0.backgroundColor = .customGray3 }
        contentsView.addSubview(lineView3)
        lineView3.snp.makeConstraints {
            $0.top.equalTo(typeStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
        }
        
        // 메모 입력 뷰
        memoTotalView.addSubview(memoTextLbl)
        memoTextLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        memoTextLbl.addSubview(memoPlaceholderLbl)
        memoPlaceholderLbl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        memoTotalView.addSubview(memoSelectView)
        memoSelectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        memoStackView.addArrangedSubview(memoTitleLbl)
        memoStackView.addArrangedSubview(memoTotalView)
        
        memoTitleLbl.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        
        contentsView.addSubview(memoStackView)
        memoStackView.snp.makeConstraints {
            $0.top.equalTo(lineView3.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        let lineView4 = UIView().then { $0.backgroundColor = .customGray3 }
        contentsView.addSubview(lineView4)
        lineView4.snp.makeConstraints {
            $0.top.equalTo(memoStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
        }
        
        
        // 저장 버튼
        scrollContentsView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalTo(questionTextLbl.snp.trailing).offset(100)
            $0.trailing.equalTo(scrollContentsView.snp.trailing)
            $0.height.equalTo(30)
        }
        
        totalView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(totalScrollView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: NewWriteBudgetReactor) {
        amountTextField.rx.text
            .orEmpty
            .map({ amount in NewWriteBudgetReactor.Action.setAmount(amount) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.amount }
            .bind(to: amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.accountResult }
            .map { accountResult -> String in
                switch accountResult {
                case .success: return ""
                case .failure(let error): return error.message
                }
            }
            .filter { !$0.isEmpty }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                let vc = TransientAlertViewController()
                vc.titleMessage = message
                owner.presentPanModal(vc)
            }
            .disposed(by: disposeBag)
        
        dateBtn.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                guard let viewcon = UIStoryboard(name: "DatePickerView", bundle: nil).instantiateViewController(identifier: "DatePickerViewController") as? DatePickerViewController else {
                    return
                }
                
                owner.presentPanModal(viewcon)
                viewcon.selectedCompletion = { time in
                    Observable.just(NewWriteBudgetReactor.Action.setDate(time))
                        .bind(to: reactor.action)
                        .disposed(by: owner.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.date }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, date in
                owner.dateTextPlaceHolder.isHidden = !date.isEmpty
                owner.dateTextLbl.text = date
            }
            .disposed(by: disposeBag)
        
        typeBtn.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let viewcon = NewSpendTypeViewController()
                owner.presentPanModal(viewcon)
                viewcon.selectedCompletion = { type in
                    Observable.just(NewWriteBudgetReactor.Action.setType(type.labelMessage))
                        .bind(to: reactor.action)
                        .disposed(by: owner.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.type }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, type in
                owner.typeTextPlaceHolder.isHidden = !type.isEmpty
                owner.typeTextLbl.text = type
            }
            .disposed(by: disposeBag)
        
        memoTextLbl.rx.text
            .orEmpty
            .scan("", accumulator: { (previous, new) -> String in
                let memoLimit = NewWriteBudgetReactor.memoLimit
                
                if new.count > memoLimit {
                    return previous
                } else {
                    return new
                }
            })
            .map { memo in NewWriteBudgetReactor.Action.setMemo(memo) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.memo }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, memo in
                owner.memoPlaceholderLbl.isHidden = !memo.isEmpty
                owner.memoTextLbl.text = memo
            }
            .disposed(by: disposeBag)
        
        saveBtn.rx.tap
            .map({ _ in NewWriteBudgetReactor.Action.saveBtnTapped })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.isValid }
            .do(onNext: { [weak self] isValid in
                self?.saveBtn.backgroundColor = isValid ? .customBlue1 : .customGray2
            })
            .bind(to: saveBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        contentsViewBtn.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.isCompleted }
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isCompleted in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        closeBtn.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isLoading in
                if isLoading {
                    owner.spinner.show(in: owner.view)
                } else {
                    owner.spinner.dismiss()
                }
            }
            .disposed(by: disposeBag)
        
        Observable.from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> CGFloat in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGFloat in 0 }
            ])
            .merge()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, height in
                owner.saveBtn.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(height > 0 ? -(height - owner.view.safeAreaInsets.bottom + 8) : 0)
                }
                
                UIView.animate(withDuration: 0.5) { [weak owner] in
                    owner?.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
}
