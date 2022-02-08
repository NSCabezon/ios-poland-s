//
//  ChequePinError.swift
//  BLIK
//
//  Created by 186491 on 16/06/2021.
//

import CoreFoundationLib

public enum ChequePinError: Error {
    case pinIsNotMatch
    
    var localizedString: String {
        switch self {
        case .pinIsNotMatch:
            return localized("pl_blik_text_diffrPass")
        }
    }
}
