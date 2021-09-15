//
//  GlobalPositionDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class GlobalPositionDTOAdapter {
    static func adaptPLGlobalPositionToGlobalPosition(_ plGlobalPosition: SANPLLibrary.GlobalPositionDTO, clientPersonCode: String) -> SANLegacyLibrary.GlobalPositionDTO {
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
        // TODO: Replace with customer API result when the API is implemented
        globalPositionDTO.clientName = "TestUser"
        globalPositionDTO.clientNameWithoutSurname = "TestUser"
        var userDataDTO: UserDataDTO = UserDataDTO()
        userDataDTO.clientPersonType = ""
        userDataDTO.clientPersonCode = clientPersonCode
        globalPositionDTO.userDataDTO = userDataDTO

        return globalPositionDTO
    }
}

private extension GlobalPositionDTOAdapter {
    private static func rearrangeAccountsByFirstMainItem(_ accounts: [SANPLLibrary.AccountDTO]?) -> [SANPLLibrary.AccountDTO] {
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
