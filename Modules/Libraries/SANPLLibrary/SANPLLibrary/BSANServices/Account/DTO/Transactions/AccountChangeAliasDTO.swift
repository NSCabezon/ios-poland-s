//
//  AccountChangeAlias.swift
//  Pods
//
//  Created by Fernando Sánchez García on 22/12/21.
//

import Foundation

public struct AccountChangeAliasDTO: Codable {
    public let systemId: Int?
    public let productId: String?
    public let userDefined: String?
}

