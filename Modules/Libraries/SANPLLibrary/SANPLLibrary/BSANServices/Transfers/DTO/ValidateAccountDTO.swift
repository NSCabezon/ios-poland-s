//
//  ValidateAccountDTO.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 20/10/21.
//

import CoreDomain

struct ValidateAccountTransferDTO: ValidateAccountTransferRepresentable {
    var transferNationalDTO: TransferNationalRepresentable?
    var errorCode: String?
}
