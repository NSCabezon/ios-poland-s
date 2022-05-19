//
//  PLSimpleGlobalPositionModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 4/5/22.
//

import Foundation
import GlobalPosition
import SANLegacyLibrary
import CoreFoundationLib

public class PLSimpleGlobalPositionModifier: SimpleGlobalPositionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    public var isHomeFundAvailable: Bool = false
    
    init(resolver: DependenciesResolver) {
        self.dependenciesResolver = resolver
    }
    
    public func displayInfo(for saving: SavingProductEntity) -> (subtitle: String?, descriptionKey: String?) {
        switch saving.dto.accountSubType {
        case PLSavingTransactionsRepositoryProductType.goals.rawValue:
            return(nil, "pgBasket_label_balance")
        default:
            guard let numberFormat = self.dependenciesResolver.resolve(forOptionalType: AccountNumberFormatterProtocol.self) else {
                return(saving.contractNumber, "pgBasket_label_balance")
            }
            return(numberFormat.accountNumberFormat(saving.contractNumber), "pgBasket_label_balance")
        }
    }
}
