//
//  LoginModels.swift
//  PLLogin

public struct LoginChallengeEntity {
    public let authorizationType: String?
    public let value: String?
}

public struct TrustedComputerEntity {
    public let state: String?
    public let register: Bool?
}

public enum UserIdentifierType {
    case nik
    case alias
}

public enum PasswordType {
    case normal
    case masked(mask: Int)
}

struct SecondFactorDataEntity {
    let defaultChallenge: DefaultChallengeEntity
}

public struct DefaultChallengeEntity: Encodable {
    let authorizationType, value: String
}

public struct SecondFactorDataAuthenticateEntity {
    let response: ResponseEntity
}

public struct ResponseEntity {
    let challenge: ChallengeEntity
    let value: String
}

public struct ChallengeEntity {
    let authorizationType, value: String
}
