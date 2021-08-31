//
//  LoginModels.swift
//  PLLogin

import SANPLLibrary

public struct ChallengeEntity {
    public let authorizationType: AuthorizationType
    public let value: String
    init(authorizationType: AuthorizationType, value: String) {
        self.authorizationType = authorizationType
        self.value = value
    }
}

public struct TrustedComputerEntity {
    public let state: String?
    public let register: Bool?
}

public enum PasswordType {
    case normal
    case masked(mask: Int)
}

struct SecondFactorDataEntity {
    let defaultChallenge: ChallengeEntity
}

public struct SecondFactorDataAuthenticationEntity {
    let challenge: ChallengeEntity
    let value: String
}

public struct EncryptionKeyEntity {
    let modulus: String
    let exponent: String
}

enum LoginType {
    case notPersisted(info: LoginTypeInfo)
    case persisted(info: LoginTypeInfo)

    var indentification: String {
        switch self {
        case .notPersisted(let info): return info.identification
        case .persisted(let info): return info.identification
        }
    }
}

struct LoginTypeInfo {
    var identification: String = ""
}
