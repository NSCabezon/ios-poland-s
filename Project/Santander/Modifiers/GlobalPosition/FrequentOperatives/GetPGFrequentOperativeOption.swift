//
//  GetPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/5/21.
//

import CoreFoundationLib
import Commons

final class GetPGFrequentOperativeOption {
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
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
        var options: [PGFrequentOperativeOptionProtocol] = [PGFrequentOperativeOption.operate,
                                                            PaymentsPGFrequentOperativeOption(dependenciesResolver: self.dependenciesResolver),
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
