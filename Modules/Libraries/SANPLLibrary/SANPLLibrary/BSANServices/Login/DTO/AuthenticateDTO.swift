//
//  AuthenticateDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 20/5/21.
//

import Foundation

public struct AuthenticateDTO: Codable {
    public let userId, userCif, expires, expires_in: Int?
    public let companyContext, trusted_device_token: Bool?
    public let type, access_token, client_id: String?
}
