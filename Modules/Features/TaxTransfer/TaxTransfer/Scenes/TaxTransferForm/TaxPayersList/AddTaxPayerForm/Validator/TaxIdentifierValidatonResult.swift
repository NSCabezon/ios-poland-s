//
//  TaxIdentifierValidatonResult.swift
//  TaxTransfer
//
//  Created by 187831 on 29/04/2022.
//

import Foundation

enum TaxIdentifierValidatonResult: Equatable {
    case valid
    case invalid(String?)
}
