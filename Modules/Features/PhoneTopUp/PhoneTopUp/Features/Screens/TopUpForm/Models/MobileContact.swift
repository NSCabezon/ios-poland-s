//
//  Contact.swift
//  Account
//
//  Created by 188216 on 23/12/2021.
//

import Foundation

public struct MobileContact {
    let fullName: String
    let phoneNumber: String
    let color = UIColor.random
    
    var initials: String {
        return fullName.components(separatedBy: " ").prefix(2).compactMap({ $0.first.map(String.init) }).joined()
    }
}
