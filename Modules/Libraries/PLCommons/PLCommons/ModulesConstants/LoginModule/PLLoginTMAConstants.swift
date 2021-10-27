//
//  PLLoginTMAConstants.swift
//  PLCommons
//
//  Created by Juan Sánchez Marín on 22/10/21.
//

import Foundation
import Commons

public struct PLLoginTrustedDeviceDeviceDataPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/home"
    public enum Action: String {
        case clickContinue = "click_continue"
        case clickCancel = "click_cancel"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLLoginTrustedDevicePinPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/pin"
    public enum Action: String {
        case info = "info"
        case enableBiometry = "enable_biometry"
        case clickContinue = "click_continue"
        case clickCancel = "click_cancel"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLLoginTrustedDeviceVoiceBotPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/pin/ivr"
    public enum Action: String {
        case clickContinue = "click_continue"
        case clickCancel = "click_cancel"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLLoginTrustedDeviceSMSAuthPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/pin/ivr/otp"
    public enum Action: String {
        case info = "info"
        case clickContinue = "click_continue"
        case clickCancel = "click_cancel"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLLoginTrustedDeviceHardwareTokenPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/pin/ivr/hw_token"
    public enum Action: String {
        case info = "info"
        case clickContinue = "click_continue"
        case clickCancel = "click_cancel"
        case apiError = "api_error"
    }
    public init() {}
}

public struct PLLoginTrustedDeviceSuccessPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "/tma/thankyou"
    public enum Action: String {
        case info = "info"
        case clickContinue = "click_continue"
    }
    public init() {}
}
