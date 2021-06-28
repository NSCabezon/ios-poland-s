//
//  PLLoginType.swift
//  PLLogin

import Foundation

enum LoginType {
    case notPersisted(info: LoginTypeInfo)
    case persisted(info: LoginTypeInfo)

    var indentification: String {
        switch self {
        case .notPersisted(let info): return info.identification
        case .persisted(let info): return info.identification
        }
    }
}

enum AuthLogin {
    case magic(String)
}

struct LoginTypeInfo {
    var identification: String = ""
}
