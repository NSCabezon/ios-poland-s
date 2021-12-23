//
//  TransactionParameters.swift
//  PLCryptography
//
//  Created by 187830 on 15/11/2021.
//

public struct TransactionParameters: Codable {
    public let joinedParameters: String
    
    public init(joinedParameters: String) {
        self.joinedParameters = joinedParameters
    }
}
