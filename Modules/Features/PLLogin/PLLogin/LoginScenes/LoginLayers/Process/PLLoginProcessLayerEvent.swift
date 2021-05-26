//
//  PLLoginProcessLayerEvent.swift
//  PLLogin

import Foundation

public enum LoginProcessLayerEvent {
    case willLogin
    case loginSuccess
    case loginError
    case accountTemporaryLocked(seconds: String?)
    case wrongCredentials
    case noConnection
    case permanentlyBlocked
}
