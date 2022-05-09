//
//  FundTransactionListDTO.swift
//  SANPLLibrary
//
//  Created by Alberto Talavan Bustos on 24/2/22.
//

import CoreDomain
import SANLegacyLibrary

public struct FundTransactionListDTO: Codable {
    public let entries: [FundTransactionDTO]?
    public let more: Bool?
}

extension FundTransactionListDTO: FundMovementListRepresentable {
    public var transactions: [FundMovementRepresentable] {
        self.entries ?? []
    }

    public var next: PaginationRepresentable? {
        if let more = self.more, more {
            var paginationDTO = PaginationDTO()
            paginationDTO.endList = false
            return paginationDTO
        } else {
            return nil
        }
    }
}
