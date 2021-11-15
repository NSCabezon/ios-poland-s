//
//  LoginConfigurations.swift
//  PLLogin

import Models

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

public enum RememberedLoginType: Equatable {
    case Pin (value: String)
    case Biometrics
    
    public func getString() -> String{
        switch self {
        case .Pin(value: _): return "PIN"
        case .Biometrics: return "BIOMETRICS"
        }
    }
}



public final class RememberedLoginConfiguration {

    public var userIdentifier: String
    public let isTrustedDevice: Bool
    public var isBiometricsAvailable: Bool
    public var isPinAvailable: Bool
    public var isDemoUser: Bool = false
    public var userPref: RememberedLoginUserPreferencesConfiguration?
    public var unblockRemainingTimeInSecs: Double?
    public var secondFactorDataFinalState: String?
    public var challenge: ChallengeEntity?
    public var pendingChallenge: PLRememberedLoginPendingChallenge?
    
    public init(userIdentifier: String,
                isBiometricsAvailable: Bool = false,
                isPinAvailable: Bool = false,
                isTrustedDevice: Bool = false) {
        self.userIdentifier = userIdentifier
        self.isBiometricsAvailable = isBiometricsAvailable
        self.isPinAvailable = isPinAvailable
        self.isTrustedDevice = isTrustedDevice
    }
    
    public func isFinal() -> Bool {
        return secondFactorDataFinalState?.elementsEqual("FINAL") ?? false
    }
    
    public func isBlocked() -> Bool {
        return (secondFactorDataFinalState?.elementsEqual("BLOCKED") ?? false) && unblockRemainingTimeInSecs != nil
    }
}

public struct RememberedLoginUserPreferencesConfiguration {
    let name: String?
    let theme: BackgroundImagesTheme
    let biometricsEnabled: Bool
}
