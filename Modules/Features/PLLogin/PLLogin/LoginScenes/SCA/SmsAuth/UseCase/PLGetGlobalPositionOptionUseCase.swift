//
//  PLGetGlobalPositionOptionUseCase.swift
//  PLLogin
//
//  Created by Rodrigo Jurado on 21/6/21.
//

import DomainCommon
import Commons
import Repository
import Models
import SANPLLibrary

final class PLGetGlobalPositionOptionUseCase: UseCase<Void, GetGlobalPositionOptionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetGlobalPositionOptionUseCaseOkOutput, StringErrorOutput> {
        let appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
        let persistedUser = appRepository.getPersistedUser()
        let userId: String?
        if persistedUser.isSuccess(), let persistedUserDTO = try persistedUser.getResponseData() {
            userId = persistedUserDTO.userId
        } else {
            let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
            let authCredentials = try managerProvider.getLoginManager().getAuthCredentials()
            if let id = authCredentials.userId {
                userId = String(id)
            } else {
                userId = nil
            }
        }
        return .ok(self.getGlobalPositionOption(userId))
    }
}

private extension PLGetGlobalPositionOptionUseCase {
    func getGlobalPositionOption(_ userId: String?) -> GetGlobalPositionOptionUseCaseOkOutput {
        guard let userId = userId else {
            return GetGlobalPositionOptionUseCaseOkOutput(globalPositionOption: .classic, userId: nil)
        }
        let appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
        let userPref = appRepository.getUserPreferences(userId: userId)
        if let globalPositionOption = GlobalPositionOptionEntity(rawValue: userPref.pgUserPrefDTO.globalPositionOptionSelected) {
            return GetGlobalPositionOptionUseCaseOkOutput(globalPositionOption: globalPositionOption, userId: userId)
        } else {
            return GetGlobalPositionOptionUseCaseOkOutput(globalPositionOption: .classic, userId: userId)
        }
    }
}

struct GetGlobalPositionOptionUseCaseOkOutput {
    let globalPositionOption: GlobalPositionOptionEntity
    let userId: String?
}
