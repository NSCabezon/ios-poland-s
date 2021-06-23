//
//  UnrememberedLoginConfiguration.swift
//  PLLogin

/// This model will be inyected as dependency to pass information between login scenes
public final class UnrememberedLoginConfiguration {

    public let userIdentifier: String
    public let passwordType: PasswordType
    public let challenge: ChallengeEntity
    public let loginImageData: String?
    public var password: String?
    public let secondFactorDataFinalState: String

    public init(userIdentifier: String, passwordType: PasswordType, challenge: ChallengeEntity, loginImageData: String?, password: String?, secondFactorDataFinalState: String) {
        self.userIdentifier = userIdentifier
        self.passwordType = passwordType
        self.challenge = challenge
        self.loginImageData = loginImageData
        self.password = password
        self.secondFactorDataFinalState = secondFactorDataFinalState
    }
}
