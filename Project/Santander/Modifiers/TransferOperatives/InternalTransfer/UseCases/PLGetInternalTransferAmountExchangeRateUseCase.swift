//
//  PLGetInternalTransferAmountExchangeRateUseCase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 2/3/22.
//

import Foundation
import OpenCombine
import CoreDomain
import TransferOperatives
import SANPLLibrary

struct PLGetInternalTransferAmountExchangeRateUseCase {
    let transfersRepository: PLTransfersRepository
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
    }
}

extension PLGetInternalTransferAmountExchangeRateUseCase: GetInternalTransferAmountExchangeRateUseCase {
    
    func fetchExchangeRate(input: GetInternalTransferAmountExchangeRateUseCaseInput) -> AnyPublisher<GetInternalTransferAmountExchangeRateUseCaseOutput, Error> {
        let fromCurrency = input.initialCurrency
        let toCurrency = input.targetCurrency
        let localCurrency = input.localCurrency
        return transfersRepository.getExchangeRates().tryMap { rates in
            guard fromCurrency != toCurrency else {
                return .success(result: getOutputWith(fromCurrency: fromCurrency, toCurrency: toCurrency, sell: 1.0, buy: nil))
            }
            guard fromCurrency != localCurrency && toCurrency != localCurrency else {
                let foreignCurrency = fromCurrency != localCurrency ? fromCurrency : toCurrency
                guard let rate = rates.first(where: { rates in
                    rates.currency.uppercased() == foreignCurrency.rawValue.uppercased()
                }) else {
                    return .failure
                }
//                let sellRate = fromCurrency == localCurrency ? rate.sellRate : 1 / rate.sellRate
                let sellRate = rate.sellRate
                return .success(result: getOutputWith(fromCurrency: fromCurrency, toCurrency: toCurrency, sell: sellRate, buy: nil))
            }
            guard let sellRate = rates.first(where: { rates in
                rates.currency.uppercased() == fromCurrency.rawValue.uppercased()
            })?.sellRate else {
                return .failure
            }
            guard let buyRate = rates.first(where: { rates in
                rates.currency.uppercased() == toCurrency.rawValue.uppercased()
            })?.buyRate else {
                return .failure
            }
            return .success(result: getOutputWith(fromCurrency: fromCurrency, toCurrency: toCurrency, sell: sellRate, buy: buyRate))
        }
        .eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferAmountExchangeRateUseCase {
    func getOutputWith(fromCurrency: CurrencyType, toCurrency: CurrencyType, sell: Decimal, buy: Decimal?) -> GetInternalTransferAmountExchangeRateUseCaseSuccessOutput {
        return GetInternalTransferAmountExchangeRateUseCaseSuccessOutput(initialCurrency: fromCurrency,
                                                                         targetCurrency: toCurrency,
                                                                         sellRate: sell, buyRate: buy)
    }
}
