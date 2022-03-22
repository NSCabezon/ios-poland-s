//
//  PLInternalTransferSummaryModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 22/3/22.
//

import TransferOperatives
import CoreDomain
import SANPLLibrary

final class PLInternalTransferSummaryModifier: InternalTransferSummaryModifierProtocol {
    var additionalFeeKey: String = ""
    var additionalFeeLinkKey: String?
    var additionalFeeLink: String?
    var additionalFeeIconKey: String = "icnInfo"
    
    func freeTransferFor(originAccount: AccountRepresentable, destinationAccount: AccountRepresentable, date: Date) -> Bool {
        guard let origin = originAccount as? PolandAccountRepresentable else { return true }
        switch origin.type {
        case .creditCard:
            additionalFeeKey = "pl_summary_label_commissionsPercentage"
            additionalFeeLinkKey = nil
            return false
        case .savings:
            additionalFeeKey = "summary_label_additionalFee"
            additionalFeeLinkKey = "summary_label_seeFeeCharges"
            additionalFeeLink = "https://www.santander.pl/przydatne-informacje/oplaty-i-prowizje"
            return false
        default:
            return true
        }
    }
}
