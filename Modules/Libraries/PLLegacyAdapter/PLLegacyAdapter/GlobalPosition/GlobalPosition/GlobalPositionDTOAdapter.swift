//
//  GlobalPositionDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class GlobalPositionDTOAdapter {
    static func adaptPLGlobalPositionToGlobalPosition(_ plGlobalPosition: SANPLLibrary.GlobalPositionDTO) -> SANLegacyLibrary.GlobalPositionDTO {
        var globalPositionDTO = SANLegacyLibrary.GlobalPositionDTO()

        let rearrangedAccounts = self.rearrangeAccountsByFirstMainItem(plGlobalPosition.accounts)
        let accounts: [SANLegacyLibrary.AccountDTO]? = rearrangedAccounts.compactMap({ account -> SANLegacyLibrary.AccountDTO? in
            return AccountDTOAdapter.adaptPLAccountToAccount(account)
        })
        let cards = plGlobalPosition.cards?.compactMap({ card -> SANLegacyLibrary.CardDTO? in
            return CardDTOAdapter.adaptPLCardToCard(card)
        })
        let funds = plGlobalPosition.investmentFunds?.compactMap({ investmentFund -> SANLegacyLibrary.FundDTO? in
            return InvestmentFundsDTOAdapter.adaptPLInvestimentFundsToInvestimentFunds(investmentFund)
        })
        let loans = plGlobalPosition.loans?.compactMap({ loan -> SANLegacyLibrary.LoanDTO? in
            return LoanDTOAdapter.adaptPLLoanToLoan(loan)
        })
        let deposits = plGlobalPosition.deposits?.compactMap({ deposit -> SANLegacyLibrary.DepositDTO? in
            return DepositDTOAdapter.adaptPLDepositToDeposit(deposit)
        })

        globalPositionDTO.accounts = accounts
        globalPositionDTO.cards = cards
        globalPositionDTO.funds = funds
        globalPositionDTO.loans = loans
        globalPositionDTO.deposits = deposits

        return globalPositionDTO
    }
}

private extension GlobalPositionDTOAdapter {
    static func rearrangeAccountsByFirstMainItem(_ accounts: [SANPLLibrary.AccountDTO]?) -> [SANPLLibrary.AccountDTO] {
        guard var rearrangedAccounts = accounts else { return [] }
        guard rearrangedAccounts.first?.defaultForPayments != true,
            let index = (rearrangedAccounts.firstIndex { $0.defaultForPayments == true }) else {
            return rearrangedAccounts
        }
        let element = rearrangedAccounts.remove(at: index)
        rearrangedAccounts.insert(element, at: 0)
        return rearrangedAccounts
    }
}