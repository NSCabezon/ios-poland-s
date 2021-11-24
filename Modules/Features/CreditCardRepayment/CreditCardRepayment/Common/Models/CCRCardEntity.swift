import Foundation
import Models
import SANPLLibrary
import SANLegacyLibrary

struct CCRCardEntity: Equatable {
    
    public let pan: String
    public let displayPan: String
    public let alias: String
    
    public let relatedAccount: CCRAccountEntity
    public let totalPaymentAmount: AmountEntity
    public let minimalPaymentAmount: AmountEntity
    
    public let expirationDate: String?
    
    public let accountType: Int
    public let sequenceNumber: Int
    
    static func == (lhs: CCRCardEntity, rhs: CCRCardEntity) -> Bool {
        lhs.pan == rhs.pan
    }
}

extension CCRCardEntity {
    static func mapCardFromDTO(_ cardDTO: CCRCardDTO) -> CCRCardEntity? {
        guard let relatedAccount = cardDTO.relatedAccount,
              let pan = cardDTO.virtualPan,
              let displayPan = cardDTO.maskedPan,
              let totalPaymentAmount = cardDTO.creditCardAccountDetails?.totalRepaymentAmount,
              let minimalPaymentAmount = cardDTO.creditCardAccountDetails?.minimumRepaymentAmount,
              let accountType = relatedAccount.accountDetails?.accountType,
              let sequenceNumber = relatedAccount.accountDetails?.sequenceNumber,
              let ccrRelatedAccount = CCRAccountEntity.mapAccountFromDTO(relatedAccount)
        else { return nil }
        return CCRCardEntity(
            pan: pan,
            displayPan: displayPan,
            alias: cardDTO.name?.userDefined ?? cardDTO.name?.description ?? "",
            relatedAccount: ccrRelatedAccount,
            totalPaymentAmount: CCRAccountEntity.amount(from: totalPaymentAmount),
            minimalPaymentAmount: CCRAccountEntity.amount(from: minimalPaymentAmount),
            expirationDate: cardDTO.expirationDate,
            accountType: accountType,
            sequenceNumber: sequenceNumber
        )
    }
}
