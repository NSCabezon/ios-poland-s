//
//  PLLoginConstants.swift
//  PLCommons
//
//  Created by Juan Sánchez Marín on 14/10/21.
//

import Foundation
import CoreFoundationLib

public enum PLLoginTrackConstants {
    public static let referer = "referer"
    public static let trustedImage = "trusted_image"
    public static let errorCode = "error_code"
    public static let errorDescription = "error_description"
    public static let loginType = "login_type"
    public static let pin = "PIN"
    public static let touchID = "touchID"
    public static let faceID = "faceID"
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

public struct PLRememberedLoginPage: PageWithActionTrackable {
    static public let pin = "/login/known_user/pin"
    static public let biometric = "/login/known_user/biometric"

    public typealias ActionType = Action
    public let page: String
    public enum Action: String {
        case clickBlik = "click_blik"
        case clickPin = "click_pin"
        case clickBiometric = "click_biometric"
        case userPermanentlyBlocked = "user_permanently_blocked"
        case userTemporarilyBlocked = "user_temporarily_blocked"
        case loginSuccess = "login_success"
        case info = "info"
        case apiError = "api_error"
    }
    
    public init(_ page: String) {
        self.page = page
    }
}

public struct PLTermsAndConditionsPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/login/term_and_condition"
    public enum Action: String {
        case scrollDown = "scroll_down"
        case clickAccept = "click_accept"
        case clickCancel = "click_cancel"
    }
    public init() {}
}
