//
//  XCConfig.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import Foundation

struct XCConfig {
    
    private static var infoDictionary: [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }
    
    static subscript(key: String) -> String? {
        return self.infoDictionary[key] as? String
    }
    
    static subscript(key: String) -> [String]? {
        guard let value = self.infoDictionary[key] as? String else { return nil }
        return value.split(" ")
    }
    
    static subscript(key: String) -> Bool? {
        guard let value = self.infoDictionary[key] as? String else { return nil }
        return value == "YES"
    }
}
