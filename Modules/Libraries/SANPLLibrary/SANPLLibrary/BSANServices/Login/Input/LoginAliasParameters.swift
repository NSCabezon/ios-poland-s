//
//  LoginAliasParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 13/5/21.
//

import Foundation

public struct LoginAliasParameters: Encodable {
    let userAlias: String
    
    public init(userAlias: String) {
        self.userAlias = userAlias
    }
}
