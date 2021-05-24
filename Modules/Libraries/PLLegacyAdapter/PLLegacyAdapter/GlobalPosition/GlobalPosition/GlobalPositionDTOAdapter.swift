//
//  GlobalPositionDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class GlobalPositionDTOAdapter {
    func adaptPLGlobalPositionToGlobalPosition(_ plGlobalPosition: SANPLLibrary.GlobalPositionDTO) -> SANLegacyLibrary.GlobalPositionDTO {
        var globalPositionDTO = SANLegacyLibrary.GlobalPositionDTO()

        let rearrangedAccounts = self.rearrangeAccountsByFirstMainItem(plGlobalPosition.accounts)
        let accounts: [SANLegacyLibrary.AccountDTO]? = rearrangedAccounts.compactMap{ account -> SANLegacyLibrary.AccountDTO? in
            return AccountDTOAdapter().adaptPLAccountToAccount(account)
        }
        let cards = plGlobalPosition.cards?.compactMap({ card -> SANLegacyLibrary.CardDTO? in
            let cardDTOAdapter = CardDTOAdapter()
            return cardDTOAdapter.adaptPLCardToCard(card)
        })
        let loans = plGlobalPosition.loans?.compactMap({ loan -> SANLegacyLibrary.LoanDTO? in
            return LoanDTOAdapter().adaptPLLoanToLoan(loan)
        })
        let deposits = plGlobalPosition.deposits?.compactMap({ deposit -> SANLegacyLibrary.DepositDTO? in
            let depositDTOAdapter = DepositDTOAdapter()
            return depositDTOAdapter.adaptPLDepositToDeposit(deposit)
        })

        globalPositionDTO.accounts = accounts
        globalPositionDTO.cards = cards
        globalPositionDTO.loans = loans
        globalPositionDTO.deposits = deposits

        return globalPositionDTO
    }
}

private extension GlobalPositionDTOAdapter {
    func rearrangeAccountsByFirstMainItem(_ accounts: [SANPLLibrary.AccountDTO]?) -> [SANPLLibrary.AccountDTO] {
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
