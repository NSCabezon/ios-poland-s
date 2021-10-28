//
//  BlikAliasMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

import SANPLLibrary

protocol BlikAliasMapping {
    func map(_ dto: BlikAliasDTO) throws -> BlikAlias
}

final class BlikAliasMapper: BlikAliasMapping {
    enum Error: Swift.Error {
        case dateParsingFailure
    }
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func map(_ dto: BlikAliasDTO) throws -> BlikAlias {
        let proposalDate: Date? = try {
            guard let date = dto.proposalDate else { return nil }
            return try parseDate(from: date)
        }()
        return BlikAlias(
            walletId: dto.walletId,
            label: dto.aliasLabel,
            type: mapType(dto.aliasValueType),
            alias: dto.alias,
            acquirerId: dto.acquirerId,
            merchantId: dto.merchantId,
            expirationDate: try parseDate(from: dto.expirationDate),
            proposalDate: proposalDate,
            status: dto.status,
            aliasUsage: dto.aliasUsage
        )
    }
    
    private func parseDate(from dateString: String) throws -> Date {
        guard let date = dateFormatter.date(from: dateString) else {
            throw Error.dateParsingFailure
        }
        return date
    }
    
    private func mapType(_ type: BlikAliasDTO.AliasType) -> BlikAlias.AliasType {
        switch type {
        case .mobileDevice:
            return .mobileDevice
        case .internetShop:
            return .internetShop
        case .internetBrowser:
            return .internetBrowser
        case .contactlessHCE:
            return .contactlessHCE
        }
    }
}
