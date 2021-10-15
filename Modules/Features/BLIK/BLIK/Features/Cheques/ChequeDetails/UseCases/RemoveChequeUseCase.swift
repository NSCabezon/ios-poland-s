//
//  RemoveChequeUseCase.swift
//  BLIK
//
//  Created by 186491 on 17/06/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol RemoveChequeUseCaseProtocol: UseCase<Int, Void, StringErrorOutput> {}

final class RemoveChequeUseCase: UseCase<Int, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(managersProvider: PLManagersProviderProtocol) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: Int) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().cancelCheque(chequeId: requestValues)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension RemoveChequeUseCase: RemoveChequeUseCaseProtocol {}
