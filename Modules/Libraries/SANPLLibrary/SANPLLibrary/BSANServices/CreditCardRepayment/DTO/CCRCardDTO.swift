import Foundation

public struct CCRCardDTO: Codable {
    public let maskedPan: String? // Is used to display
    public let virtualPan: String? // Is used as id
    public let generalStatus: String?
    public let cardStatus: String?
    public let role: String?
    public let type: String?
    public let productCode: String?
    public let name: CardNameDTO?
    public let relatedAccount: CCRAccountDTO?
    public let expirationDate: String?
    public let availableBalance: BalanceDTO?
    public let creditLimit: BalanceDTO?
    public let disposedAmount: BalanceDTO?
    public let creditCardAccountDetails: CreditCardDetailsDTO?
}

public extension CCRCardDTO {
    static func mapFromCardDTO(_ cardDTO: CardDTO, account: CCRAccountDTO?, creditCardAccountDetails: CreditCardDetailsDTO?) -> CCRCardDTO {
        return CCRCardDTO(
            maskedPan: cardDTO.maskedPan,
            virtualPan: cardDTO.virtualPan,
            generalStatus: cardDTO.generalStatus,
            cardStatus: cardDTO.cardStatus,
            role: cardDTO.role,
            type: cardDTO.type,
            productCode: cardDTO.productCode,
            name: cardDTO.name,
            relatedAccount: account,
            expirationDate: cardDTO.expirationDate,
            availableBalance: cardDTO.availableBalance,
            creditLimit: cardDTO.creditLimit,
            disposedAmount: cardDTO.disposedAmount,
            creditCardAccountDetails: creditCardAccountDetails
        )
    }
}

extension CCRCardDTO: CardDTOByPanComparable {
    public var panIdentifier: String? {
        self.virtualPan
    }
}
