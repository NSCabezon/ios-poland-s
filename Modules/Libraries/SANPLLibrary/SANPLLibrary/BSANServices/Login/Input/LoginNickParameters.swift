//
//  LoginNickParameters.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public struct LoginNickParameters: Encodable {
    let userId: String
    
    public init(userId: String) {
        self.userId = userId
    }
}
