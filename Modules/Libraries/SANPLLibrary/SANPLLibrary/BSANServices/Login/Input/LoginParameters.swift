//
//  LoginNickParameters.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public struct LoginParameters: Encodable {
    let userId, userAlias: String?
    
    public init(userId: String? = nil, userAlias: String? = nil) {
        self.userId = userId
        self.userAlias = userAlias
    }
}
