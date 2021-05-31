//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation

public enum LoginProcessLayerEvent {
    case willLogin
    case loginWithIdentifierSuccess(configuration: UnrememberedLoginConfiguration)
    case loginSuccess
    case loginError
    case noConnection
}
