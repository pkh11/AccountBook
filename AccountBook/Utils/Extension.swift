//
//  Commons.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/06.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func toString(format: String = "MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Int {
    var withComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.string(from: self as NSNumber)!
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIColor {
    static let customBlack: UIColor = UIColor(named: "CustomBlack")!
    static let customBlue1: UIColor = UIColor(named: "CustomBlue1")!
    static let customBlue2: UIColor = UIColor(named: "CustomBlue2")!
    static let customBlue3: UIColor = UIColor(named: "CustomBlue3")!
    static let customGray1: UIColor = UIColor(named: "CustomGray1")!
    static let customGray2: UIColor = UIColor(named: "CustomGray2")!
    static let customGray3: UIColor = UIColor(named: "CustomGray3")!
}
