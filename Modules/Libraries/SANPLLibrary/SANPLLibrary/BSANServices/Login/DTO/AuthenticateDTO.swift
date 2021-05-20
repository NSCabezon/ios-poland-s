//
//  AuthenticateDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 20/5/21.
//

import Foundation

public struct AuthenticateDTO: Codable {
    public let userId, passwordMask: Int?
    public let passwordMaskEnabled: Bool?
}
