//
//  PLLoginConstants.swift
//  PLCommons
//
//  Created by Juan Sánchez Marín on 14/10/21.
//

import Foundation
import Commons

public struct PLLoginTrackConstants {
    public let referer = "referer"
    public let trustedImage = "trusted_image"
    public let errorCode = "error_code"
    public let errorDescription = "error_description"
    public let loginType = "login_type"

    public init() {}
}

public struct PLUnrememberedLoginOnboardingPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/unknown_user"
    public enum Action: String {
        case clickActivateApp = "click_activate_app"
        case clickOpenAccount = "click_open_account"
    }
    public init() {}
}

public struct PLUnrememberedLoginPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/enrol"
    public enum Action: String {
        case clickInitSession = "click_init_session"
        case info = "info"
        case userPermanentlyBlocked = "user_permanently_blocked"
        case userTemporarilyBlocked = "user_temporarily_blocked"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLUnrememberedLoginNormalPasswordPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/enrol/unmasked"
    public enum Action: String {
        case clickInitSession = "click_init_session"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLUnrememberedLoginMaskedPasswordPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/enrol/masked"
    public enum Action: String {
        case clickInitSession = "click_init_session"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLUnrememberedLoginSMSAuthPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/sca/otp"
    public enum Action: String {
        case clickInitSession = "click_init_session"
        case info = "info"
        case loginSuccess = "login_success"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLUnrememberedLoginHardwareTokenPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/sca/hw_token"
    public enum Action: String {
        case clickInitSession = "click_init_session"
        case info = "info"
        case loginSuccess = "login_success"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLRememberedLoginPinPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/known_user/pin"
    public enum Action: String {
        case clickBlik = "click_blik"
        case clickRecoverPassword = "click_recover_password"
        case clickBiometric = "click_biometric"
        case clickActivateTouchID = "click_activate_touchID"
        case userPermanentlyBlocked = "user_permanently_blocked"
        case userTemporarilyBlocked = "user_temporarily_blocked"
        case loginSuccess = "login_success"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLRememberedLoginBiometricPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/known_user/biometric"
    public enum Action: String {
        case clickPin = "click_pin"
        case userPermanentlyBlocked = "user_permanently_blocked"
        case userTemporarilyBlocked = "user_temporarily_blocked"
        case loginSuccess = "login_success"
        case apiError = "api_error"
    }
    public init() {}
}
