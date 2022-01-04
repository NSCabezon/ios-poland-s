//
//  TestCompilation.swift
//  PLLogin_ExampleTests
//
//  Created by Mario Rosales Maillo on 29/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SANPLLibrary

public final class PLHostProvider {
    public let environmentDefault: BSANPLEnvironmentDTO
    
    init() {
        self.environmentDefault = BSANEnvironments.environmentTest
    }
}

// MARK: - Private Methods
extension PLHostProvider: PLHostProviderProtocol {
    public func getEnvironments() -> [BSANPLEnvironmentDTO] {
        return [BSANEnvironments.environmentTest]
    }
}

public struct BSANEnvironments {
    private enum EnvironmentsConstants {
        enum TEST {
            static let name = "TEST"
            static let endpoint = ""
            static let blikAuthBaseUrl = ""
            static let restOauthClientId = ""
        }
    }
    
    public static let environmentTest = BSANPLEnvironmentDTO(name: EnvironmentsConstants.TEST.name,
                         blikAuthBaseUrl: EnvironmentsConstants.TEST.blikAuthBaseUrl,
                         urlBase: EnvironmentsConstants.TEST.endpoint,
                         clientId: EnvironmentsConstants.TEST.restOauthClientId)
}
