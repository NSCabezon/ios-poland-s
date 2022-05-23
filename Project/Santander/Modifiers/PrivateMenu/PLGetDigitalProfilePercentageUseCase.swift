//
//  PLGetDigitalProfilePercentageUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 21/4/22.
//

import PrivateMenu
import OpenCombine
import CoreDomain

struct PLGetDigitalProfilePercentageUseCase {
    private let personalAreaRepository: PersonalAreaRepository
    
    init(dependencies: PrivateMenuExternalDependenciesResolver) {
        self.personalAreaRepository = dependencies.resolve()
    }
}

extension PLGetDigitalProfilePercentageUseCase: GetDigitalProfilePercentageUseCase {
    func fetchDigitalProfilePercentage() -> AnyPublisher<Double, Error> {
        return personalAreaRepository.fetchDigitalProfilePercentage()
            .map { $0.percentage }
            .eraseToAnyPublisher()
    }
    
    func fetchIsDigitalProfileEnabled() -> AnyPublisher<Bool, Never> {
        return Just(false)
            .eraseToAnyPublisher()
    }
}
