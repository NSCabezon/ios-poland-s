//
//  ServicesLibrary.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import CoreDomain
import SANLegacyLibrary

public final class ServicesLibrary {
    
    var bsanManagersProvider: PLManagersProviderProtocol
    private let bsanDataProvider: BSANDataProvider
    private let networkProvider: NetworkProvider
    private let loansManagerAdapter: PLLoansManagerAdapterProtocol
    private let cardManagerAdapter: PLCardManagerAdapterProtocol
    
    public init(bsanManagersProvider: PLManagersProviderProtocol,
                bsanDataProvider: BSANDataProvider,
                networkProvider: NetworkProvider,
                loansManagerAdapter: PLLoansManagerAdapterProtocol, cardManagerAdapter: PLCardManagerAdapterProtocol) {
        self.bsanManagersProvider = bsanManagersProvider
        self.bsanDataProvider = bsanDataProvider
        self.networkProvider = networkProvider
        self.loansManagerAdapter = loansManagerAdapter
        self.cardManagerAdapter = cardManagerAdapter
    }
    
    public var transfersRepository: PLTransfersRepository {
        return TransfersDataRepository(bsanTransferManager: self.bsanManagersProvider.getTransferManager())
    }
    
    public var oneAuthorizationProcessorRepository: PLOneAuthorizationProcessorRepository {
        return OneAuthorizationProcessorDataRepository(bsanAuthorizationProcessorManager: self.bsanManagersProvider.getAuthorizationProcessorManager())
    }
    
    public var loanReactiveDataRepository: LoanReactiveRepository {
        return LoanReactiveDataRepository(bsanDataProvider: bsanDataProvider,
                                          networkProvider: networkProvider,
                                          loansManager: loansManagerAdapter)
    }
    
    public var onboardingDataRepository: OnboardingRepository {
        return OnboardingDataRepository(customerManager: bsanManagersProvider.getCustomerManager(),
                                        bsanDataProvider: bsanDataProvider)
    }
    
    public var cardReactiveDataRepository: CardReactiveDataRepository {
        return CardReactiveDataRepository(bsanDataProvider: bsanDataProvider,
                                          networkProvider: networkProvider, cardManager: cardManagerAdapter)
                                    
    }
}

