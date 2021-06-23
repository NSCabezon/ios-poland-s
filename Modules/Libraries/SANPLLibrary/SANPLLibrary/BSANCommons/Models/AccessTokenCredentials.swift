//
//  AccessTokenCredentials.swift
//  SANPLLibrary
//

import Foundation

public struct AccessTokenCredentials: Codable {
    public let type: String?
    public let accessToken: String?
    public let expires: Int?

    public init(type: String?, accessToken: String?, expires: Int?) {
        self.type = type
        self.accessToken = accessToken
        self.expires = expires
    }
}
