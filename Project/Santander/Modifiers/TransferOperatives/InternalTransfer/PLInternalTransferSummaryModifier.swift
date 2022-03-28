//
//  PLInternalTransferSummaryModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 22/3/22.
//

import TransferOperatives
import CoreFoundationLib
import CoreDomain
import SANPLLibrary

final class PLInternalTransferSummaryModifier: InternalTransferSummaryModifierProtocol {
    let accountOtherOperativesInfoRepository: PLAccountOtherOperativesInfoRepository
    var additionalFeeKey: String = ""
    var additionalFeeLinkKey: String?
    var additionalFeeLink: String?
    var additionalFeeIconKey: String = "icnInfo"
    
    public init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.accountOtherOperativesInfoRepository = dependencies.resolve()
    }
    
    func freeTransferFor(originAccount: AccountRepresentable, destinationAccount: AccountRepresentable, date: Date) -> Bool {
        guard let origin = originAccount as? PolandAccountRepresentable else { return true }
        switch origin.type {
        case .creditCard:
            additionalFeeKey = "pl_summary_label_commissionsPercentage"
            additionalFeeLinkKey = nil
            return false
        case .savings:
            guard let operative = accountOtherOperativesInfoRepository.get()?.sendMoneyOptions?.first(where: { operative in
                operative.id == "FEE_AND_CHARGES"
            }) else { return true }
            additionalFeeKey = "summary_label_additionalFee"
            additionalFeeLinkKey = "summary_label_seeFeeCharges"
            additionalFeeLink = operative.url
            return false
        default:
            return true
        }
    }
}
