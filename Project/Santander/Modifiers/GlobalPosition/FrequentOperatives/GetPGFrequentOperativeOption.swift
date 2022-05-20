//
//  GetPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/5/21.
//

import CoreFoundationLib
import CoreDomain
import RetailLegacy

final class GetPGFrequentOperativeOption {
    private let legacyDependenciesResolver: DependenciesResolver
    private let dependencies: ModuleDependencies
    
    init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
        self.legacyDependenciesResolver = dependencies.resolve()
    }
}

extension GetPGFrequentOperativeOption: GetPGFrequentOperativeOptionProtocol {
    func get(globalPositionType: GlobalPositionOptionEntity?) -> [PGFrequentOperativeOptionProtocol] {
        switch globalPositionType {
        case .simple:
            return self.getPGSimpleFrecuenteOperatives()
        default:
            return self.getPGFrecuenteOperatives()
        }
    }
    
    func getDefault() -> [PGFrequentOperativeOptionProtocol] {
        return self.getPGFrecuenteOperatives()
    }
}

private extension GetPGFrequentOperativeOption {
    func getPGSimpleFrecuenteOperatives() -> [PGFrequentOperativeOptionProtocol] {
        return [
            PGFrequentOperativeOption.operate,
            PaymentsPGFrequentOperativeOption(dependencies: dependencies),
            TransactionHistoryPGSimpleFrequentOperativeOption(),
            BLIKPGSimpleFrequentOperativeOption(dependencyResolver: legacyDependenciesResolver)
        ]
    }
    
    func getPGFrecuenteOperatives() -> [PGFrequentOperativeOptionProtocol] {
        var options: [PGFrequentOperativeOptionProtocol] = [
            PGFrequentOperativeOption.operate,
            PaymentsPGFrequentOperativeOption(dependencies: dependencies),
            TransactionHistoryPGFrequentOperativeOption(),
            BLIKPGFrequentOperativeOption(dependencyResolver: legacyDependenciesResolver),
            PLHelpCenterFrequentOperativeOption(dependencyResolver: legacyDependenciesResolver),
            OurOfferPGFrequentOperativeOption(dependenciesResolver: legacyDependenciesResolver),
            PGFrequentOperativeOption.impruve,
            AtmsAndBranchesPGFrequentOperativeOption(),
            PGFrequentOperativeOption.personalArea,
            AddBanksPGFrequentOperativeOption(dependenciesResolver: legacyDependenciesResolver),
            CurrencyExchangePGFrequentOperativeOption(dependenciesResolver: legacyDependenciesResolver),
            OpenGoalPGFrequentOperativeOption(),
            OpenDepositPGFrequentOperativeOption(dependenciesResolver: legacyDependenciesResolver),
            BuyInsurancePGFrequentOperativeOption(),
            CustomerServicePGFrequentOperativeOption(dependenciesResolver: legacyDependenciesResolver),
            AccountStatementPGFrequentOperativeOption(),
            PGFrequentOperativeOption.carbonFootprint
        ]
        #if DEBUG
        options.append(PLDebugMenuFrequentOperativeOption(dependencyResolver: legacyDependenciesResolver))
        #endif
        return options
    }
}
