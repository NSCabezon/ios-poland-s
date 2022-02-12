//
//  LoginInfoDTO.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 14/1/22.
//

import Foundation

public struct LoginInfoDTO: Codable {
    public let noOfLogins: Int?
    public let noOfBadLoginAttempts: Int?
    public let lastLogin: String?
    public let lastBadLoginAttempt: String?
    public let hasActiveAlias: Bool?
}
