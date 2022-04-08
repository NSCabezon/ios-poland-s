import CoreFoundationLib
import Foundation
import SANPLLibrary
import PLCommons

public protocol AccountForDebitMapping {
    func map(dto: DebitAccountDTO) throws -> AccountForDebit
}

public final class AccountForDebitMapper: AccountForDebitMapping {
    public func map(dto: DebitAccountDTO) throws -> AccountForDebit {
        return AccountForDebit(
            id: dto.id,
            name: dto.name.userDefined.isEmpty ? dto.name.description : dto.name.userDefined,
            number: dto.number,
            availableFunds: Money(
                amount: dto.availableFunds.value,
                currency: dto.availableFunds.currencyCode
            ),
            defaultForPayments: dto.defaultForPayments,
            type: AccountForDebit.AccountType(rawValue: dto.type) ?? .OTHER,
            accountSequenceNumber: dto.accountDetails.sequenceNumber,
            accountType: dto.accountDetails.accountType,
            taxAccountNumber: dto.taxAccountNumber ?? ""
        )
    }

    public init() {}
}
