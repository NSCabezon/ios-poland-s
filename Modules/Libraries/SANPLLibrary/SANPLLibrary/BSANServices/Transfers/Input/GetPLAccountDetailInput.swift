//
//  GetPLAccountDetailInput.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 17/5/22.
//

import Foundation

public struct GetPLAccountDetailInput: Codable {
    let accountNumber: String
    
    public init(accountNumber: String) {
        self.accountNumber = accountNumber
    }
}
