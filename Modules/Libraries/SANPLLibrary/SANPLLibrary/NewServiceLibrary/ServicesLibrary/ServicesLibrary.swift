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

    public init(bsanManagersProvider: PLManagersProviderProtocol) {
        self.bsanManagersProvider = bsanManagersProvider
    }
    
    public var transfersRepository: PLTransfersRepository {
        return TransfersDataRepository(bsanTransferManager: self.bsanManagersProvider.getTransferManager())
    }
    
    public var oneAuthorizationProcessorRepository: PLOneAuthorizationProcessorRepository {
        return OneAuthorizationProcessorDataRepository(bsanAuthorizationProcessorManager: self.bsanManagersProvider.getAuthorizationProcessorManager())
    }
}
