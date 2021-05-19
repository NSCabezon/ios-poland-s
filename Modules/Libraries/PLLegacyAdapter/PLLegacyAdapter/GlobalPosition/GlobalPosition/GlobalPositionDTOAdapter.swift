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
        globalPositionDTO.accounts = accounts

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
