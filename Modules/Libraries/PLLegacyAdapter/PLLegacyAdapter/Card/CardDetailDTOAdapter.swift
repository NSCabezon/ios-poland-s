//
//  CardDetailDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Juan Sánchez Marín on 21/9/21.
//

import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib

final class CardDetailDTOAdapter {

    static func adaptPLCreditCardToCardDetail(_ plCard: SANPLLibrary.CardDetailDTO) -> SANLegacyLibrary.CardDetailDTO {
        var cardDataDTO = SANLegacyLibrary.CardDetailDTO()
        cardDataDTO.availableAmount = AmountAdapter.adaptBalanceToAmount(plCard.relatedAccountData?.availableFunds)
        cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToAmount(plCard.relatedAccountData?.balance)
        cardDataDTO.creditLimitAmount = AmountAdapter.adaptBalanceToAmount(plCard.relatedAccountData?.creditLimit)
        cardDataDTO.holder = plCard.emboss1 + " " + plCard.emboss2
        cardDataDTO.beneficiary = plCard.emboss1 + " " + plCard.emboss2
        cardDataDTO.expirationDate = DateFormats.toDate(string: plCard.cardExpirationDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        cardDataDTO.currency = plCard.relatedAccountData?.availableFunds?.currencyCode
        cardDataDTO.creditCardAccountNumber = plCard.relatedAccountData?.accountNo
        cardDataDTO.interestRate = PercentAdapter.adaptValueToPercentPresentation(Double(plCard.creditCardAccountDetails?.interestRate ?? 0))
        cardDataDTO.withholdings = AmountAdapter.adaptBalanceToAmount(plCard.relatedAccountData?.withholdingBalance)
        cardDataDTO.previousPeriodInterest = AmountAdapter.adaptBalanceToAmount(plCard.creditCardAccountDetails?.interestForPreviousPeriod)
        cardDataDTO.minimumOutstandingDue = AmountAdapter.adaptBalanceToAmount(plCard.creditCardAccountDetails?.outstandingMinimumDueAmount)
        cardDataDTO.currentMinimumDue = AmountAdapter.adaptBalanceToAmount(plCard.creditCardAccountDetails?.currentMinimumDueAmount)
        cardDataDTO.totalMinimumRepaymentAmount = AmountAdapter.adaptBalanceToAmount(plCard.creditCardAccountDetails?.minimumRepaymentAmount)
        cardDataDTO.lastStatementDate = DateFormats.toDate(string: plCard.creditCardAccountDetails?.lastStatementDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        cardDataDTO.nextStatementDate = DateFormats.toDate(string: plCard.creditCardAccountDetails?.nextStatementDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        cardDataDTO.actualPaymentDate = DateFormats.toDate(string: plCard.creditCardAccountDetails?.paymentDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        return cardDataDTO
    }

    static func adaptPLDebitCardToCardDetail(_ plCard: SANPLLibrary.CardDetailDTO) -> SANLegacyLibrary.CardDetailDTO {
        var cardDataDTO = SANLegacyLibrary.CardDetailDTO()
        cardDataDTO.holder = plCard.emboss1 + " " + plCard.emboss2
        cardDataDTO.beneficiary = plCard.emboss1 + " " + plCard.emboss2
        cardDataDTO.expirationDate = DateFormats.toDate(string: plCard.cardExpirationDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        cardDataDTO.currency = plCard.relatedAccountData?.availableFunds?.currencyCode
        cardDataDTO.linkedAccountDescription = plCard.relatedAccountData?.accountNo
        cardDataDTO.insurance = (plCard.insuranceFlag ?? false) ? localized("generic_link_yes") : localized("generic_link_no")
        return cardDataDTO
    }
}
