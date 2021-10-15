//
//  PLTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import CoreDomain

public protocol PLTransfersRepository: TransfersRepository {
    func getAccountForDebit() throws -> Result<[AccountRepresentable], Error>
}

