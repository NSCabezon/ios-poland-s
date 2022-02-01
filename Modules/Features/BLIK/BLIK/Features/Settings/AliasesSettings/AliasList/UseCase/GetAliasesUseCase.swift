//
//  GetAliasesUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

import CoreFoundationLib
import Foundation
import CoreFoundationLib
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
            if let blikError = BlikError(with: error.getErrorBody()),
               blikError.errorCode1 == .customerTypeDisabled,
               blikError.errorCode2 == .p2pAliasNotExsist {
                return .ok([])
            } else {
                return .error(.init(error.localizedDescription))
            }
        }
    }
}

extension GetAliasesUseCase: GetAliasesUseCaseProtocol {}
