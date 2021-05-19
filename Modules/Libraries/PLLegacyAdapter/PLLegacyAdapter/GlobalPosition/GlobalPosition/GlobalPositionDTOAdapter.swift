//
//  GlobalPositionDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class GlobalPositionDTOAdapter {
    func adaptPLGlobalPositionToGlobalPosition(_ plGlobalPosition: SANPLLibrary.GlobalPositionDTO) -> SANLegacyLibrary.GlobalPositionDTO {
        var globalPositionDTO = SANLegacyLibrary.GlobalPositionDTO()
        let rearrangeAccounts = self.rearrangeAccountsByFirstMainItem(plGlobalPosition.accounts)
        let accounts: [SANLegacyLibrary.AccountDTO]? = rearrangeAccounts.compactMap{ account -> SANLegacyLibrary.AccountDTO? in
            return AccountDTOAdapter().adaptPLAccountToAccount(account)
        }
        globalPositionDTO.accounts = accounts

        return globalPositionDTO
    }
}

private extension GlobalPositionDTOAdapter {
    func rearrangeAccountsByFirstMainItem(_ accounts: [SANPLLibrary.AccountDTO]?) -> [SANPLLibrary.AccountDTO] {
        guard var rearrangeAccounts = accounts else { return [] }
        guard rearrangeAccounts.first?.defaultForPayments != true,
            let index = (rearrangeAccounts.firstIndex { $0.defaultForPayments == true }) else {
            return rearrangeAccounts
        }
        let element = rearrangeAccounts.remove(at: index)
        rearrangeAccounts.insert(element, at: 0)
        return rearrangeAccounts
    }
}
