//
//  GetAliasesUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol GetAliasesUseCaseProtocol: UseCase<Void, [BlikAlias], StringErrorOutput> {}

final class GetAliasesUseCase: UseCase<Void, [BlikAlias], StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let modelMapper: BlikAliasMapping
    
    init(
        managersProvider: PLManagersProviderProtocol,
        modelMapper: BlikAliasMapping
    ) {
        self.managersProvider = managersProvider
        self.modelMapper = modelMapper
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<[BlikAlias], StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getAliases()
        switch result {
        case let .success(dtos):
            do {
                let models = try dtos.map { try modelMapper.map($0) }
                return .ok(models)
            } catch {
                return .error(.init(error.localizedDescription))
            }
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetAliasesUseCase: GetAliasesUseCaseProtocol {}
