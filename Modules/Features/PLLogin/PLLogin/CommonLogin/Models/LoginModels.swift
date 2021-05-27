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
    case masked
}
