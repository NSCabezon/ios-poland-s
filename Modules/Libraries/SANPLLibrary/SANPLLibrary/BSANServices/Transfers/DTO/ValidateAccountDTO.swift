//
//  ValidateAccountDTO.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 20/10/21.
//

import CoreDomain

struct ValidateAccountTransferDTO: ValidateAccountTransferRepresentable {
    var transferNationalRepresentable: TransferNationalRepresentable?
    var errorCode: String?
}
