//
//  GetPLCurrentEnvironmentUseCase.swift
//  PLLogin

import Foundation
import CoreFoundationLib
import SANLegacyLibrary
import SANPLLibrary
import CoreFoundationLib

final class GetPLCurrentEnvironmentUseCase: UseCase<Void, GetCurrentBSANEnvironmentUseCaseOkOutput, GetCurrentBSANEnvironmentUseCaseErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    private var plManagersProvider: PLManagersProviderProtocol {
        return dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    private var appRepository: AppRepositoryProtocol {
        return dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetCurrentBSANEnvironmentUseCaseOkOutput, GetCurrentBSANEnvironmentUseCaseErrorOutput> {
        guard let publicFilesEnvironmentDto = try appRepository.getCurrentPublicFilesEnvironment().getResponseData(),
              case .success(let plEnvironmentDTO) = plManagersProvider.getEnvironmentsManager().getCurrentEnvironment() else {
            return UseCaseResponse.error(GetCurrentBSANEnvironmentUseCaseErrorOutput("Found a nil value at GetCurrentEnvironmentUseCase."))
        }
        let publicFilesEnvironmentEntity = PublicFilesEnvironmentEntity(publicFilesEnvironmentDto)
        let bsanEnvironmentEntity = PLEnvironmentEntity(plEnvironmentDTO)
        return UseCaseResponse.ok(GetCurrentBSANEnvironmentUseCaseOkOutput(bsanEnvironment: bsanEnvironmentEntity, publicFilesEnvironment: publicFilesEnvironmentEntity))
    }
}

class GetCurrentBSANEnvironmentUseCaseOkOutput {
    let bsanEnvironment: PLEnvironmentEntity
    let publicFilesEnvironment: PublicFilesEnvironmentEntity

    init(bsanEnvironment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.bsanEnvironment = bsanEnvironment
        self.publicFilesEnvironment = publicFilesEnvironment
    }
}

class GetCurrentBSANEnvironmentUseCaseErrorOutput: StringErrorOutput { }

