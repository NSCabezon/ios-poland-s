//
//  GetPhoneTopUpFormDataUseCase.swift
//  PhoneTopUp
//
//  Created by 188216 on 30/11/2021.
//

import CoreFoundationLib
import Foundation
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
    
    private var contactsMapper: MobileContactMapping {
        return dependenciesResolver.resolve()
    }
    
    private var topUpAccountMapper: TopUpAccountMapping {
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
            let acccounts = sefDefaultAccountIfNeeded(for: try formDataDTO.accounts.map(accountMapper.map))
            let operators = operatorMapper.mapAndMerge(operatorDTOs: formDataDTO.operators, gsmOperatorDTOs: formDataDTO.gsmOperators)
            let internetContacts = formDataDTO.internetContacts.compactMap(contactsMapper.map)
            let topUpAccount = topUpAccountMapper.map(dto: formDataDTO.topUpAccount)
            return .ok(GetPhoneTopUpFormDataOutput(accounts: acccounts,
                                                   operators: operators,
                                                   internetContacts: internetContacts,
                                                   topUpAccount: topUpAccount))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
    
    private func sefDefaultAccountIfNeeded(for accounts: [AccountForDebit]) -> [AccountForDebit] {
        if accounts.count == 1, let firstAccount = accounts.first {
            return [AccountForDebit(
                id: firstAccount.id,
                name: firstAccount.name,
                number: firstAccount.number,
                availableFunds: firstAccount.availableFunds,
                defaultForPayments: true,
                type: firstAccount.type,
                accountSequenceNumber: firstAccount.accountSequenceNumber,
                accountType: firstAccount.accountType,
                taxAccountNumber: firstAccount.taxAccountNumber)]
        } else {
            return accounts
        }
    }
}

extension GetPhoneTopUpFormDataUseCase: GetPhoneTopUpFormDataUseCaseProtocol {
}
