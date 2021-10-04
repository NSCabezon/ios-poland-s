//
//  UnrememberedLoginConfiguration.swift
//  PLLogin

/// This model will be inyected as dependency to pass information between login scenes
public final class UnrememberedLoginConfiguration {

    public let displayUserIdentifier: String
    public let userIdentifier: String
    public let passwordType: PasswordType
    public let challenge: ChallengeEntity
    public let loginImageData: String?
    public var password: String?
    public let secondFactorDataFinalState: String
    public let unblockRemainingTimeInSecs: Double?

    public init(displayUserIdentifier:String, userIdentifier: String, passwordType: PasswordType, challenge: ChallengeEntity, loginImageData: String?, password: String?, secondFactorDataFinalState: String, unblockRemainingTimeInSecs: Double?) {
        self.displayUserIdentifier = displayUserIdentifier
        self.userIdentifier = userIdentifier
        self.passwordType = passwordType
        self.challenge = challenge
        self.loginImageData = loginImageData
        self.password = password
        self.secondFactorDataFinalState = secondFactorDataFinalState
        self.unblockRemainingTimeInSecs = unblockRemainingTimeInSecs
    }
    
    public func isFinal() -> Bool {
        return secondFactorDataFinalState.elementsEqual("FINAL")
    }
    
    public func isBlocked() -> Bool {
        return secondFactorDataFinalState.elementsEqual("BLOCKED") && unblockRemainingTimeInSecs != nil
    }
}
