//
//  UIWindow+Extension.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/09/06
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
