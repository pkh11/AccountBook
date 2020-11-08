//
//  Commons.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/06.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
