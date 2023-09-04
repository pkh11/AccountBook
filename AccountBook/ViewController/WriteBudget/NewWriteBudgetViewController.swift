//
//  NewWriteBudgetViewController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/09/04
//
        

import UIKit
import RxSwift
import ReactorKit
import SnapKit
import Then

internal final class NewWriteBudgetViewController: UIViewController, StoryboardView {
    
    private lazy var totalView = UIView().then {
        $0.backgroundColor = .white
    }
    private lazy var totalScrollView = UIScrollView().then {
        $0.backgroundColor = .yellow
    }
    private lazy var closeBtn = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
    }
    
    private lazy var scrollContentsView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    
    private lazy var saveBtn = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .customBlue1
    }
    
    // MARK: - VARIABLES
    internal var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - SYSTEM FUNC
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
        
        scrollContentsView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalTo(scrollContentsView.snp.leading).offset(100)
            $0.trailing.equalTo(scrollContentsView.snp.trailing)
            $0.height.equalTo(30)
            $0.bottom.equalTo(scrollContentsView.snp.bottom).offset(-50)
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
        
    }
}
