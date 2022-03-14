//
//  PLTransactionParametersProvider.swift
//  SANPLLibrary
//
//  Created by 186484 on 02/11/2021.
//

import CoreFoundationLib
import SANPLLibrary

public protocol PLTransactionParametersProviderProtocol {
    func getTransactionParameters(type: PLDomesticTransactionParametersType?) -> TransactionParameters?
}

public class PLTransactionParametersProvider: PLTransactionParametersProviderProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    private lazy var transactionProvider: PLDomesticTransactionParametersGenerable = {
        self.dependenciesResolver.resolve(for: PLDomesticTransactionParametersGenerable.self)
    }()
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func getTransactionParameters(type: PLDomesticTransactionParametersType?) -> TransactionParameters? {
        guard let type = type else {
            return nil
        }
        switch type {
        case .transferToAnyAccount(let transactionParameters),
             .blikP2P(let transactionParameters),
             .charityTransfer(let transactionParameters),
             .splitPaymentToAnyAccount(let transactionParameters),
             .multiCurrencyTransfer(let transactionParameters),
             .foreignTransfer(let transactionParameters),
             .blikP2PR(let transactionParameters),
             .mCommerceBelow(let transactionParameters),
             .mCommerceUnder(let transactionParameters),
             .zusTransfer(let transactionParameters),
             .topUpTransfer(let transactionParameters):
            let joinedParameters = transactionProvider.getParameters(
                transactionParametersInput: transactionParameters,
                type: type
            )
            return TransactionParameters(
                joinedParameters: joinedParameters
            )
        }
    }
}

