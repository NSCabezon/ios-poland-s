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
    private let dependenciesResolver: DependenciesResolver
    private let moduleDependencies: ModuleDependencies
    
    init(moduleDependencies: ModuleDependencies) {
        self.moduleDependencies = moduleDependencies
        self.dependenciesResolver = moduleDependencies.resolve()
    }
}

extension GetPGFrequentOperativeOption: GetPGFrequentOperativeOptionProtocol {
    func get(globalPositionType: GlobalPositionOptionEntity?) -> [PGFrequentOperativeOptionProtocol] {
        return self.getPGFrecuenteOperatives()
    }
    
    func getDefault() -> [PGFrequentOperativeOptionProtocol] {
        return self.getPGFrecuenteOperatives()
    }
}

private extension GetPGFrequentOperativeOption {
    func getPGFrecuenteOperatives() -> [PGFrequentOperativeOptionProtocol] {
        var options: [PGFrequentOperativeOptionProtocol] = [
            PGFrequentOperativeOption.operate,
            PaymentsPGFrequentOperativeOption(dependencies: moduleDependencies),
            TransactionHistoryPGFrequentOperativeOption(),
            BLIKPGFrequentOperativeOption(dependencyResolver: dependenciesResolver),
            PLHelpCenterFrequentOperativeOption(dependencyResolver: dependenciesResolver),
            OurOfferPGFrequentOperativeOption(dependenciesResolver: dependenciesResolver),
            PGFrequentOperativeOption.impruve,
            AtmsAndBranchesPGFrequentOperativeOption(),
            PGFrequentOperativeOption.personalArea,
            AddBanksPGFrequentOperativeOption(dependenciesResolver: dependenciesResolver),
            CurrencyExchangePGFrequentOperativeOption(dependenciesResolver: dependenciesResolver),
            OpenGoalPGFrequentOperativeOption(),
            OpenDepositPGFrequentOperativeOption(),
            BuyInsurancePGFrequentOperativeOption(),
            CustomerServicePGFrequentOperativeOption(dependenciesResolver: dependenciesResolver),
            AccountStatementPGFrequentOperativeOption()
        ]
        #if DEBUG
        options.append(PLDebugMenuFrequentOperativeOption(dependencyResolver: dependenciesResolver))
        #endif
        return options
    }
}
