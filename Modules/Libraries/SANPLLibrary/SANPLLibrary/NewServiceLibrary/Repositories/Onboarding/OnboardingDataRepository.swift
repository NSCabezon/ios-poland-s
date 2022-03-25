//
//  OnboardingDataRepository.swift
//  SANPLLibrary
//
//  Created by Jose Camallonga on 4/2/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib
import OpenCombine

public struct OnboardingDataRepository: OnboardingRepository {
    private let customerManager: PLCustomerManagerProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(customerManager: PLCustomerManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.customerManager = customerManager
        self.bsanDataProvider = bsanDataProvider
    }
    
    public func getOnboardingInfo() -> AnyPublisher<OnboardingInfoRepresentable, Error> {
        return Future<OnboardingInfoRepresentable, Error> { promise in
            DispatchQueue.main.async {
                guard let individual = try? customerManager.getIndividual().get(),
                      let userId = try? bsanDataProvider.getAuthCredentials().userId,
                      let name = individual.firstName else {
                          promise(.failure(NetworkProviderError.other))
                          return
                      }
                promise(.success(OnboardingInfo(identifier: String(userId), name: name.capitalized)))
            }
        }.eraseToAnyPublisher()
    }
}

public struct OnboardingInfo: OnboardingInfoRepresentable {
    public let identifier: String
    public let name: String
}

