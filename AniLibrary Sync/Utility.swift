//
//  Utility.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/13.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation

public class Utility : NSObject {
    static func base64Encoding(string:String) -> String {
        let plaindata : Data = string.data(using: .utf8)!
        let base64string = plaindata.base64EncodedString()
        return base64string
    }
}
