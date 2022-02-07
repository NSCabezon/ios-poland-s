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
        return dependenciesResolver.resolve()
    }
    
    private var operatorMapper: OperatorMapping {
        return dependenciesResolver.resolve()
    }
    
    private var gsmOperatorMapper: GSMOperatorMapping {
        return dependenciesResolver.resolve()
    }
    
    private var contactsMapper: MobileContactMapping {
        return dependenciesResolver.resolve()
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
        case .success(let formDataDTO):
            let acccounts = try formDataDTO.accounts.map(accountMapper.map)
            let gsmOperators = formDataDTO.gsmOperators.map(gsmOperatorMapper.map)
            let operators = formDataDTO.operators.map(operatorMapper.map)
            let internetContacts = formDataDTO.internetContacts.compactMap(contactsMapper.map)
            return .ok(GetPhoneTopUpFormDataOutput(accounts: acccounts, operators: operators, gsmOperators: gsmOperators, internetContacts: internetContacts))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetPhoneTopUpFormDataUseCase: GetPhoneTopUpFormDataUseCaseProtocol {
}
