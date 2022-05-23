//
//  PLGetInternalTransferAmountExchangeRateUseCase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 2/3/22.
//

import TransferOperatives
import SANPLLibrary
import OpenCombine
import CoreDomain

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
        return transfersRepository.getExchangeRates()
            .tryMap { rates in
                guard fromCurrency != toCurrency else {
                    return .success(result: getOutputWith(
                        fromCurrency: fromCurrency,
                        toCurrency: toCurrency,
                        sell: 1.0,
                        buy: 1.0
                    ))
                }
                guard fromCurrency != localCurrency && toCurrency != localCurrency else {
                    let foreignCurrency = fromCurrency != localCurrency ? fromCurrency : toCurrency
                    guard let rate = getRate(from: foreignCurrency, rates: rates) else {
                        return .failure
                    }
                    let sellRate = rate.sellRate
                    return .success(result: getOutputWith(
                        fromCurrency: fromCurrency,
                        toCurrency: toCurrency,
                        sell: sellRate,
                        buy: rate.buyRate
                    ))
                }
                guard let sellRate = getRate(from: fromCurrency, rates: rates)?.sellRate,
                      let buyRate = getRate(from: toCurrency, rates: rates)?.buyRate
                else { return .failure }
                return .success(
                    result: getOutputWith(
                        fromCurrency: fromCurrency,
                        toCurrency: toCurrency,
                        sell: sellRate,
                        buy: buyRate
                    )
                )
            }
            .eraseToAnyPublisher()
    }
}

private extension PLGetInternalTransferAmountExchangeRateUseCase {
    func getOutputWith(fromCurrency: CurrencyType, toCurrency: CurrencyType, sell: Decimal, buy: Decimal) -> GetInternalTransferAmountExchangeRateUseCaseSuccessOutput {
        return GetInternalTransferAmountExchangeRateUseCaseSuccessOutput(
            initialCurrency: fromCurrency,
            targetCurrency: toCurrency,
            sellRate: sell,
            buyRate: buy
        )
    }
    
    func getRate(from currency: CurrencyType, rates: [ExchangeRateRepresentable]) -> ExchangeRateRepresentable? {
        return rates.first(where: { rate in
            rate.currency.uppercased() == currency.rawValue.uppercased()
        })
    }
}
