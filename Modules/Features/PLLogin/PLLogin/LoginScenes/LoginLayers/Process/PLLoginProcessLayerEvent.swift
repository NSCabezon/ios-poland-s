//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation

public enum LoginProcessLayerEvent {
    case willLogin
    case loginWithIdentifierSuccess(passwordType: PasswordType)
    case pubKeyRetrieved(key: String)
    case loginSuccess
    case loginError
    case noConnection
}
