//
//  AcceptTaxTransactionUseCase.swift
//  TaxTransfer
//
//  Created by 187831 on 06/04/2022.
//

import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol AcceptTaxTransactionProtocol: UseCase<AcceptTaxTransactionUseCaseInput,
                                       AcceptTaxTransactionUseCaseOkOutput,
                                       StringErrorOutput> { }

final class AcceptTaxTransactionUseCase: UseCase<AcceptTaxTransactionUseCaseInput,
                                         AcceptTaxTransactionUseCaseOkOutput,
                                         StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let taxTransferSummaryMapper: TaxTransferSummaryMapping
    private let taxTransferSendMoneyInputMapper: TaxTransferSendMoneyInputMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.taxTransferSummaryMapper = dependenciesResolver.resolve(for: TaxTransferSummaryMapping.self)
        self.taxTransferSendMoneyInputMapper = dependenciesResolver.resolve(for: TaxTransferSendMoneyInputMapping.self)
    }
    
    override func executeUseCase(requestValues: AcceptTaxTransactionUseCaseInput) throws -> UseCaseResponse<AcceptTaxTransactionUseCaseOkOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("#userId not exists"))
        }
        let sendMoneyConfirmationInput = taxTransferSendMoneyInputMapper.map(model: requestValues.model, userId: userId)
        let result = try managersProvider.getTransferManager().sendConfirmation(sendMoneyConfirmationInput)
        
        switch result {
        case let .success(result):
            return .ok(.init(summary: taxTransferSummaryMapper.map(with: result)))
        case let .failure(error):
            return prepareErrorMessages(with: error)
        }
    }
    
    private func prepareErrorMessages(with error: NetworkProviderError) -> UseCaseResponse<AcceptTaxTransactionUseCaseOkOutput, StringErrorOutput> {
        switch error {
        case .noConnection:
            return .error(.init(AcceptTaxTransactionErrorResult.noConnection.rawValue))
        default:
            let taxTransferError = TaxTransferError(with: error.getErrorBody())
            return .error(.init(taxTransferError?.errorResult.rawValue))
        }
    }
}

extension AcceptTaxTransactionUseCase: AcceptTaxTransactionProtocol {
    
}

struct AcceptTaxTransactionUseCaseInput {
    let model: TaxTransferModel
}

struct AcceptTaxTransactionUseCaseOkOutput {
    let summary: TaxTransferSummary
}
