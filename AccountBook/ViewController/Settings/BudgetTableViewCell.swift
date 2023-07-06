//
//  BudgetTableViewCell.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/14.
//  Copyright © 2023 FastCampus. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Then

internal final class BudgetTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var titleLbl = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    // MARK: - VARIABLES
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - SYSTEM FUNC
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func makeUI() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.contentView.snp.makeConstraints {
            $0.height.equalTo(55)
        }

        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(18)
        }
    }
    
    internal func bind(reactor: BudgetCellReactor) {
        titleLbl.text = "예산"
    }
}
