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
    
    public init(bsanManagersProvider: PLManagersProviderProtocol,
                bsanDataProvider: BSANDataProvider,
                networkProvider: NetworkProvider,
                loansManagerAdapter: PLLoansManagerAdapterProtocol) {
        self.bsanManagersProvider = bsanManagersProvider
        self.bsanDataProvider = bsanDataProvider
        self.networkProvider = networkProvider
        self.loansManagerAdapter = loansManagerAdapter
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
}

