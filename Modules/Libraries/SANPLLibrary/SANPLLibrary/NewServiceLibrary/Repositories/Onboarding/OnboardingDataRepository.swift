//
//  OnboardingDataRepository.swift
//  SANPLLibrary
//
//  Created by Jose Camallonga on 4/2/22.
//

import Foundation
import CoreDomain
import OpenCombine
import CoreFoundationLib

public struct OnboardingDataRepository: OnboardingRepository {
    private let customerManager: PLCustomerManagerProtocol
    private let globalPosition: GlobalPositionRepresentable
    
    public init(customerManager: PLCustomerManagerProtocol, globalPosition: GlobalPositionRepresentable) {
        self.customerManager = customerManager
        self.globalPosition = globalPosition
    }
    
    public func getOnboardingInfo() -> AnyPublisher<OnboardingInfoRepresentable, Error> {
        return Future<OnboardingInfoRepresentable, Error> { promise in
            DispatchQueue.main.async {
                    guard let individual = try? customerManager.getIndividual().get(),
                      let userId = globalPosition.userId, let name = individual.firstName else {
                          promise(.failure(NetworkProviderError.other))
                          return
                      }
                promise(.success(OnboardingInfo(id: String(userId), name: name.capitalized)))
            }
        }.eraseToAnyPublisher()
    }
}

// swiftlint:disable identifier_name
public struct OnboardingInfo: OnboardingInfoRepresentable {
    public let id: String
    public let name: String
}

