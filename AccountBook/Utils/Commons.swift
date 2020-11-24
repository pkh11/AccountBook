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

extension String {
    func convert(_ value: String) -> SpendType.RawValue {
        switch value {
        case "대중교통":
            return SpendType.대중교통.rawValue
        case "식사":
            return SpendType.식사.rawValue
        case "보험":
            return SpendType.보험.rawValue
        case "술자리":
            return SpendType.술자리.rawValue
        case "커피":
            return SpendType.커피.rawValue
        case "물건구입":
            return SpendType.물건구입.rawValue
        default:
            return SpendType.기타.rawValue
        }
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
    static let customBlack: UIColor = UIColor(named: "Customblack")!
    static let customBlue1: UIColor = UIColor(named: "Customblue1")!
    static let customBlue2: UIColor = UIColor(named: "Customblue2")!
    static let customBlue3: UIColor = UIColor(named: "Customblue3")!
    static let customGray1: UIColor = UIColor(named: "Customgray1")!
    static let customGray2: UIColor = UIColor(named: "Customgray2")!
    static let customGray3: UIColor = UIColor(named: "Customgray3")!
}
