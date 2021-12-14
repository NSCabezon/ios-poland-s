//
//  GetPhoneTopUpFormDataUseCase.swift
//  PhoneTopUp
//
//  Created by 188216 on 30/11/2021.
//

import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import PLCommonOperatives

public protocol GetPhoneTopUpFormDataUseCaseProtocol: UseCase<Void, GetPhoneTopUpFormDataOutput, StringErrorOutput> {
}

public final class GetPhoneTopUpFormDataUseCase: UseCase<Void, GetPhoneTopUpFormDataOutput, StringErrorOutput> {
    
    // MARK: Properties
    
    private let dependenciesResolver: DependenciesResolver

    private var accountMapper: AccountForDebitMapping {
        return dependenciesResolver.resolve(for: AccountForDebitMapping.self)
    }
    
    private var managersProvider: PLManagersProviderProtocol {
        return dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    private var phoneTopUpManager: PLPhoneTopUpManagerProtocol {
        return managersProvider.getPhoneTopUpManager()
    }
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    // MARK: Methods
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetPhoneTopUpFormDataOutput, StringErrorOutput> {
        let results = try phoneTopUpManager.getFormData()
        switch results {
        case .success(let accountDTOs):
            let accounts = try accountDTOs.map { try accountMapper.map(dto: $0) }
            return .ok(GetPhoneTopUpFormDataOutput(accounts: accounts))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetPhoneTopUpFormDataUseCase: GetPhoneTopUpFormDataUseCaseProtocol {
}
