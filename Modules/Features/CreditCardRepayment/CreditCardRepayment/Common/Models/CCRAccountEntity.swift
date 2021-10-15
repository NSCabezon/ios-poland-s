import Foundation
import Models
import SANPLLibrary
import SANLegacyLibrary

struct CCRAccountEntity: Equatable {
    
    public let number: String
    public let alias: String
    public let id: String
    public let taxAccountId: String?
    public let currencyCode: String
    public let defaultForPayments: Bool
    
    public let currentBalanceAmount: AmountEntity
    public let availableAmount: AmountEntity
    
    public let accountType: Int
    public let sequenceNumber: Int
    
    static func == (lhs: CCRAccountEntity, rhs: CCRAccountEntity) -> Bool {
        lhs.number == rhs.number
    }
}

extension CCRAccountEntity {
    
    public var getDetailUI: String {
        // TODO: Not sure if we should prepare iban using this logic
        let iban = IBANEntity(IBANDTO(ibanString: "PL" + number)).ibanPapel
        return iban.replacingOccurrences(of: "PL", with: "")
    }
    
}

extension CCRAccountEntity {
    static func mapAccountFromDTO(_ accountDTO: CCRAccountDTO) -> CCRAccountEntity? {
        guard let accountType = accountDTO.accountDetails?.accountType,
              let sequenceNumber = accountDTO.accountDetails?.sequenceNumber
        else { return nil }
        return CCRAccountEntity(
            number: accountDTO.number,
            alias: accountDTO.alias ?? "",
            id: accountDTO.id,
            taxAccountId: accountDTO.taxAccountId,
            currencyCode: accountDTO.currencyCode,
            defaultForPayments: accountDTO.defaultForPayments,
            currentBalanceAmount: amount(from: accountDTO.balance),
            availableAmount: amount(from: accountDTO.availableFunds),
            accountType: accountType,
            sequenceNumber: sequenceNumber
        )
    }
    
    static func amount(from money: CCRAccountDTO.Money) -> AmountEntity {
        // Based on [TEET-153408]
        // All amount values are transformed to positive on this layer (similar solution is implemented on android side)
        let amountDTO = AmountDTO(
            value: Decimal(abs(money.value)),
            currency: CurrencyDTO(currencyName: money.currencyCode, currencyType: .other)
        )
        return AmountEntity(amountDTO)
    }
}
