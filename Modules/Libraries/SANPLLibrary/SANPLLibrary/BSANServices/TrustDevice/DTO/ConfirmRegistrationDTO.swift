//
//  ConfirmRegistrationDTO.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 12/8/21.
//

import Foundation

public struct ConfirmRegistrationDTO: Codable {
    public let id: Int
    public let state: String
    public let badTriesCount: Int
    public let triesAllowed: Int
    public let timestamp: Int
    public let name: String?
    public let key: String?
    public let type: String?
    public let trustedDeviceId: Int?
    public let dateOfLastStatusChange: String?
    public let properUseCount: Int?
    public let badUseCount: Int?
    public let dateOfLastProperUse: String?
    public let dateOfLastBadUse: String?
}
