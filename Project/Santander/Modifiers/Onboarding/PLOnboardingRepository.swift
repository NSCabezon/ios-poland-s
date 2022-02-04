//
//  PLOnboardingRepository.swift
//  Santander
//
//  Created by Jose Camallonga on 4/2/22.
//

import Foundation
import CoreDomain
import OpenCombine

struct PLOnboardingRepository: OnboardingRepository {
    func getOnboardingInfo() -> AnyPublisher<OnboardingInfoRepresentable, Error> {
        return Just(OnboardingInfo(id: "12345678Z", name: "Name"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct OnboardingInfo: OnboardingInfoRepresentable {
    let id: String
    let name: String
}
