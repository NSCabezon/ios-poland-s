//
//  CheckNewSendMoneyEnabledUseCase.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 22/9/21.
//

import CoreFoundationLib
import Commons

final class CheckNewSendMoneyHomeEnabledUseCase: UseCase<Void, Bool, StringErrorOutput> {
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Bool, StringErrorOutput> {
        let appConfig: AppConfigRepositoryProtocol = dependenciesResolver.resolve()
        if let enabled = appConfig.getBool("enabledNewSendMoney"), enabled {
            return .ok(true)
        } else {
            return .ok(false)
        }
    }
}
