//
//  PLSendMoneyExchangeRatesUseCase.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 25/4/22.
//

import CoreFoundationLib
import CoreDomain
import TransferOperatives
import SANPLLibrary

final class PLSendMoneyExchangeRatesUseCase: UseCase<Void, SendMoneyExchangeRatesUseCaseOkOutput, StringErrorOutput>, SendMoneyExchangeRatesUseCaseProtocol {
    
    private let transfersRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<SendMoneyExchangeRatesUseCaseOkOutput, StringErrorOutput> {
        let result = try self.transfersRepository.getExchangeRates()
        switch result {
        case .success(let rates):
            return .ok(SendMoneyExchangeRatesUseCaseOkOutput(exangeRates: rates))
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }
}
