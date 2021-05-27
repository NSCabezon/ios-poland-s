//
//  PLLoginType.swift
//  PLLogin

import Foundation

enum LoginType {
    case notPersisted(info: LoginTypeInfo)
    case persisted(info: LoginTypeInfo)
}

enum AuthLogin {
    case magic(String)
}

struct LoginTypeInfo {
    var identification: String = ""
}
