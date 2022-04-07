//
//  GetSplitPaymentFormDataUseCase.swift
//  SplitPayment
//
//  Created by 189501 on 15/03/2022.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import PLCommonOperatives

protocol GetSplitPaymentFormDataUseCaseProtocol: UseCase<Void, GetSplitPaymentFormDataOutput, StringErrorOutput> {
}

final class GetSplitPaymentFormDataUseCase: UseCase<Void, GetSplitPaymentFormDataOutput, StringErrorOutput> {
    
    // MARK: Properties
    
    private let dependenciesResolver: DependenciesResolver

    private var accountMapper: AccountForDebitMapping {
        return dependenciesResolver.resolve()
    }
    
    private var managersProvider: PLManagersProviderProtocol {
        return dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    private var splitPaymentManager: PLSplitPaymentManagerProtocol {
        return managersProvider.getSplitPaymentManager()
    }
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    // MARK: Methods
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetSplitPaymentFormDataOutput, StringErrorOutput> {
        let results = try splitPaymentManager.getFormData()
        switch results {
        case .success(let formDataDTO):
            let acccounts = try formDataDTO.accounts.map(accountMapper.map)
            return .ok(GetSplitPaymentFormDataOutput(accounts: acccounts))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetSplitPaymentFormDataUseCase: GetSplitPaymentFormDataUseCaseProtocol {
}

