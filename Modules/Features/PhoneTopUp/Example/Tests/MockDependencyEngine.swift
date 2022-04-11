//
//  MockDependencyEngine.swift
//  PhoneTopUp_Example
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
@testable import PhoneTopUp

extension DependenciesDefault {
    static func mockInstance() -> DependenciesDefault {
        let dependencies = DependenciesDefault()
        registerMockDependencies(for: dependencies)
        return dependencies
    }
    
    static func registerMockDependencies(for engine: DependenciesDefault) {
        engine.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 1, qualityOfService: .default)
        }
        
        engine.register(for: ChallengesHandlerDelegate.self) { _ in
            return MockChallengesHandlerDelegate()
        }
        
        engine.register(for: PLManagersProviderProtocol.self) { _ in
            return MockPLManagersProvider()
        }
        
        engine.register(for: UseCaseScheduler.self) { _ in
            return DispatchQueue.main
        }
    }
}
