//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation

public enum LoginProcessLayerEvent {
    case willLogin
    case loginWithIdentifierSuccess(configuration: UnrememberedLoginConfiguration)
    case authenticateInitSuccess
    case authenticateSuccess
    case loginSuccess
    case loginError
    case loginErrorAccountTemporaryBlocked
    case noConnection
}
