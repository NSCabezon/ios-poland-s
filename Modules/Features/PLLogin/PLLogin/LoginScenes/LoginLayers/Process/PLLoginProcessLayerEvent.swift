//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation

public enum LoginProcessLayerEvent {
    case willLogin
    case loginWithIdentifierSuccess(passwordType: PasswordType)
    case loginSuccess
    case loginError
    case noConnection
}
