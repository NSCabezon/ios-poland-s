//
//  Contact.swift
//  Account
//
//  Created by 188216 on 23/12/2021.
//

import Foundation

public struct MobileContact {
    public let fullName: String
    public let phoneNumber: String
    public let color = UIColor.random
    
    public var initials: String {
        return fullName.components(separatedBy: " ").prefix(2).compactMap({ $0.first.map(String.init) }).joined()
    }
    
    public init(fullName: String, phoneNumber: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }
}
