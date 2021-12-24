//
//  PLHostProviderMock.swift
//  PLCryptography_Tests
//
//  Created by 187830 on 17/11/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
import SANLegacyLibrary
import Commons
import SANLegacyLibrary
@testable import SANPLLibrary

class PLHostProviderMock: PLHostProviderProtocol {
    var environmentDefault: BSANPLEnvironmentDTO {
        getEnvironments().first!
    }
    
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        return [
            BSANPLEnvironmentDTO(name: "",
                                 blikAuthBaseUrl: "",
                                 urlBase: "",
                                 clientId: "")
        ]
    }
}
