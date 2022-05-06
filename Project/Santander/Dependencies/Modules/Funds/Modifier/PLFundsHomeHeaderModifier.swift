//
//  PLFundsHomeHeaderModifier.swift
//  Santander
//

import Funds
import CoreDomain
import SANLegacyLibrary

class PLFundsHomeHeaderModifier: FundsHomeHeaderModifier {
    var isOwnerViewEnabled: Bool = false
    var isProfitabilityDataEnabled: Bool = false
    var isShareButtonEnabled: Bool = false

    func getCustomNumber(for fund: FundRepresentable) -> String? {
        return (fund as? FundDTO)?.accountId?.id
    }
}
