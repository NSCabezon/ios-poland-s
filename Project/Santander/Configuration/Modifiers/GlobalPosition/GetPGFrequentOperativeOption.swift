//
//  GetPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/5/21.
//

import Models
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
        return [PGFrequentOperativeOption.sendMoney,
                PGFrequentOperativeOption.contract,
                PGFrequentOperativeOption.billTax,
                BLIKGPFrequentOperativeOption()
        ]
    }
}
