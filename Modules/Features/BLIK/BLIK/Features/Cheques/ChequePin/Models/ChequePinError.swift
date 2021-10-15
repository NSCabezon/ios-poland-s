//
//  ChequePinError.swift
//  BLIK
//
//  Created by 186491 on 16/06/2021.
//

import Commons

public enum ChequePinError: Error {
    case pinIsEmpty
    case pinIsNotMatch
    
    var localizedString: String {
        switch self {
        case .pinIsEmpty:
            return "#Pin nie może być pusty"
        case .pinIsNotMatch:
            return localized("pl_blik_text_diffrPass")
        }
    }
}
