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
        let accounts: [SANLegacyLibrary.AccountDTO]? = rearrangedAccounts.compactMap(AccountDTOAdapter.adaptPLAccountToAccount)
        let cards = plGlobalPosition.cards?.compactMap(CardDTOAdapter.adaptPLCardToCard)
        let funds = plGlobalPosition.investmentFunds?.compactMap(InvestmentFundsDTOAdapter.adaptPLInvestimentFundsToInvestimentFunds)
        let loans = plGlobalPosition.loans?.compactMap(LoanDTOAdapter.adaptPLLoanToLoan)
        let deposits = plGlobalPosition.deposits?.compactMap(DepositDTOAdapter.adaptPLDepositToDeposit)
        let insurances = plGlobalPosition.insurances?.compactMap(InsuranceDTOAdapter.adaptPLInsuranceToInsurance)
        let savings = plGlobalPosition.savings?.compactMap(SavingsDTOAdapter.adaptPLSavingsToSavings)
        globalPositionDTO.accounts = accounts
        globalPositionDTO.cards = cards
        globalPositionDTO.funds = funds
        globalPositionDTO.loans = loans
        globalPositionDTO.deposits = deposits
        globalPositionDTO.protectionInsurances = insurances
        globalPositionDTO.savingProducts = savings
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
