//
//  DeleteAliasUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol DeleteAliasUseCaseProtocol: UseCase<DeleteAliasRequest, Void, StringErrorOutput> {}

final class DeleteAliasUseCase: UseCase<DeleteAliasRequest, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let requestMapper: DeleteBlikAliasParametersMapping
    
    init(
        managersProvider: PLManagersProviderProtocol,
        requestMapper: DeleteBlikAliasParametersMapping
    ) {
        self.managersProvider = managersProvider
        self.requestMapper = requestMapper
    }
    
    override func executeUseCase(requestValues: DeleteAliasRequest) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let request = requestMapper.map(requestValues)
        let result = try managersProvider.getBLIKManager().deleteAlias(request)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension DeleteAliasUseCase: DeleteAliasUseCaseProtocol {}
