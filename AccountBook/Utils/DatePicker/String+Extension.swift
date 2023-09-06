//
//  String_Extension.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/09/05
//
        

import Foundation
import UIKit

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
    
    func convertToComma() -> String {
        let replacing = self.replacingOccurrences(of: ",", with: "")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
        guard let formattedNumber = formatter.number(from: replacing),
              let formattedString = formatter.string(from: formattedNumber) else { return "" }
        
        return formattedString
    }
    
    func toFloat() -> Float {
        guard let floatData = Float(self) else { return 0.0 }
        return floatData
    }
    
    func toInt() -> Int {
        guard let intData = Int(self) else { return 0 }
        return intData
    }
}
