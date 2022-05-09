//
//  UserTaxAccountMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 12/04/2022.
//

import SANPLLibrary
import PLCommons

protocol UserTaxAccountMapping {
    func map(_ dto: UserTaxAccountDTO) throws -> UserTaxAccount
}

final class UserTaxAccountMapper: UserTaxAccountMapping {
    enum Error: Swift.Error {
        case invalidDateFormat
    }
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func map(_ dto: UserTaxAccountDTO) throws -> UserTaxAccount {
        guard let lastUpdateDate = dateFormatter.date(from: dto.lastUpdate) else {
            throw Error.invalidDateFormat
        }
        
        return UserTaxAccount(
            accountNumber: dto.number,
            id: dto.id,
            systemId: dto.systemId,
            taxAccountId: dto.taxAccountId,
            currencyCode: dto.currencyCode,
            accountName: UserTaxAccount.AccountName(
                source: dto.name.source,
                description: dto.name.description,
                userDefined: dto.name.userDefined
            ),
            accountType: getAccountType(from: dto.type),
            balance: getMoney(from: dto.balance),
            availableFunds: getMoney(from: dto.availableFunds),
            lastUpdate: lastUpdateDate
        )
    }
    
    private func getMoney(from dto: MoneyDTO?) -> Money? {
        guard let dto = dto else { return nil }
        return Money(
            amount: dto.value,
            currency: dto.currencyCode
        )
    }
    
    private func getAccountType(from type: AccountForPolandTypeDTO) -> UserTaxAccount.AccountType {
        switch type {
        case .avista:
            return .AVISTA
        case .savings:
            return .SAVINGS
        case .deposit:
            return .DEPOSIT
        case .creditCard:
            return .CREDIT_CARD
        case .loan:
            return .LOAN
        case .investment:
            return .INVESTMENT
        case .vat:
            return .VAT
        case .sLink:
            return .SLINK
        case .efx:
            return .EFX
        case .other:
            return .OTHER
        case .personal:
            return .PERSONAL
        }
    }
}
