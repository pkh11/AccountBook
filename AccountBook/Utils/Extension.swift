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
    
    func toDate(_ time: String) -> Date {
        let dateString:String = time

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        return dateFormatter.date(from: dateString)!
    }
    
    func image() -> UIImage? {
        let size = CGSize(width: 35, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
