//
//  PLValidateAccountTransferRepresentable.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 7/10/21.
//

import CoreDomain

public protocol PLTransferNationalRepresentable: TransferNationalRepresentable {
    var accountNumber: String? { get }
    var currency: Int? { get }
    var currencyCode: String? { get }
}

