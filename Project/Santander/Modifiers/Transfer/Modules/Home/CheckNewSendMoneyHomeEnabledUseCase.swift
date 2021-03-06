//
//  CheckNewSendMoneyEnabledUseCase.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 22/9/21.
//

import CoreFoundationLib
import OpenCombine

protocol CheckNewSendMoneyHomeEnabledUseCase {
    func fetchEnabled() -> AnyPublisher<Bool, Never>
}

struct DefaultCheckNewSendMoneyHomeEnabledUseCase {
    let appConfigRepository: AppConfigRepositoryProtocol
    
    init(dependencies: CheckNewSendMoneyHomeEnabledUseCaseDependenciesResolver) {
        self.appConfigRepository = dependencies.resolve()
    }
}

extension DefaultCheckNewSendMoneyHomeEnabledUseCase: CheckNewSendMoneyHomeEnabledUseCase {
    func fetchEnabled() -> AnyPublisher<Bool, Never> {
        return appConfigRepository.value(for: "enableOneSendMoneyHome", defaultValue: false)
            .eraseToAnyPublisher()
    }
}
