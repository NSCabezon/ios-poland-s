//
//  AuthCredentials.swift
//  SANPLLibrary
//

import SANLegacyLibrary

public struct AuthCredentials: Codable {
    public let login: String?
    public let userId: Int?
    public let userCif: Int?
    public let companyContext: Bool?
    public let accessTokenCredentials: AccessTokenCredentials?
    public let trustedDeviceTokenCredentials: TrustedDeviceTokenCredentials?

    public init(login: String?, userId: Int?, userCif: Int?, companyContext: Bool?, accessTokenCredentials: AccessTokenCredentials?, trustedDeviceTokenCredentials: TrustedDeviceTokenCredentials?) {
        self.login = login
        self.userId = userId
        self.userCif = userCif
        self.companyContext = companyContext
        self.accessTokenCredentials = accessTokenCredentials
        self.trustedDeviceTokenCredentials = trustedDeviceTokenCredentials
    }
}

extension AuthCredentials: AuthCredentialsProvider {
    public var timelineToken: String? {
        return nil
    }
}
