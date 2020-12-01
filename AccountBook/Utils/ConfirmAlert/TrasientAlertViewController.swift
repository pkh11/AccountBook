//
//  TrasientAlertViewController.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/30.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class TransientAlertViewController: AlertViewController {

    private weak var timer: Timer?
    private var countdown: Int = 3
    var titleMessage: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        alertView.titleLabel.text = "예산이 변경되었습니다.😀"
        alertView.titleLabel.text = titleMessage ?? "알림"
        updateMessage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.countdown -= 1
            self?.updateMessage()
        }
    }

    @objc func updateMessage() {
        guard countdown > 0 else {
            invalidateTimer()
            dismiss(animated: true, completion: nil)
            return
        }
        alertView.message.text = "이 메세지는 \(countdown)초 뒤에 사라집니다. :)"
    }

    func invalidateTimer() {
        timer?.invalidate()
    }

    deinit {
        invalidateTimer()
    }

    // MARK: - Pan Modal Presentable

    override var showDragIndicator: Bool {
        return false
    }

    override var anchorModalToLongForm: Bool {
        return true
    }

    override var panModalBackgroundColor: UIColor {
        return .clear
    }

    override var isUserInteractionEnabled: Bool {
        return false
    }
}
