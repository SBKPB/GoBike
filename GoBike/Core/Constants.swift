//
//  Constants.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/14.
//

import Foundation


struct Constants {
    private static let baseUrlPath = "https://tcgbusfs.blob.core.windows.net/dotapp/youbike"
    
    struct Urls {
        static let station = URL(string: "\(baseUrlPath)/v2/youbike_immediate.json")!
    }
    
}
