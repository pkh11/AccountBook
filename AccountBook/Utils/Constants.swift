//
//  Constants.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2021/03/23.
//  Copyright © 2021 FastCampus. All rights reserved.
//

import Foundation

class Constants {
    
    static let sharedInstance = Constants()
    var admobUnitId: String
    
    private init() {
        admobUnitId = "ca-app-pub-2942820178759316/8451822973"
    }
}
