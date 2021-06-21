//
//  AuthCredentials.swift
//  SANPLLibrary
//

import SANLegacyLibrary

public class AuthCredentials: Codable {
    public let login: String?
    public let authenticate: AuthenticateDTO?

    public init(login: String? = nil, authenticate: AuthenticateDTO?) {
        self.login = login
        self.authenticate = authenticate
    }
}

extension AuthCredentials: AuthCredentialsProvider {
    public var timelineToken: String? {
        return nil
    }
}
