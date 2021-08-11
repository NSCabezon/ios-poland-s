//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation
import Commons

public enum LoginProcessLayerEvent {
    case willLogin
    case loginWithIdentifierSuccess(configuration: UnrememberedLoginConfiguration)
    case authenticateInitSuccess
    case authenticateSuccess
    case loginSuccess
    case error(type: LoginErrorType)
}
