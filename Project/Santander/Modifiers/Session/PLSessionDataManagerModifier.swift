//
//  PLSessionDataManagerModifier.swift
//  Santander
//
//  Created by Hernán Villamil on 10/11/21.
//

import Commons
import DomainCommon
import Models
import Repository

final class PLSessionDataManagerModifier: SessionDataManagerModifier {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func performAfterGlobalPosition(_ globalPosition: GlobalPositionRepresentable) -> ScenarioHandler<Void, StringErrorOutput>? {

        // TODO: Remove this when complete implementation available, this only fix the remembered login navigation
        let appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
        guard let userDto = try? appRepository.getPersistedUser().getResponseData() else { return nil }
        userDto.name = globalPosition.fullName != "" ? globalPosition.fullName : globalPosition.clientNameWithoutSurname
        userDto.userId = globalPosition.userId
        _ = appRepository.setPersistedUserDTO(persistedUserDTO: userDto)
        // ----------

        return nil
    }
    
    func performBeforePullOffers() -> ScenarioHandler<Bool, StringErrorOutput>? {
        return ScenarioHandler(scheduler: dependenciesResolver.resolve()).just(true)
    }
    
    func performBeforeFinishing() -> ScenarioHandler<Void, StringErrorOutput>? {
        return nil
    }
}
