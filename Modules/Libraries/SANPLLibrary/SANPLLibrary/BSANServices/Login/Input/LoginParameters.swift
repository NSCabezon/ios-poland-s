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

    var selectedId: String {
        if let userId = self.userId {
            return userId
        } else if let userAlias = self.userAlias {
            return userAlias
        } else {
            return ""
        }
    }
}
