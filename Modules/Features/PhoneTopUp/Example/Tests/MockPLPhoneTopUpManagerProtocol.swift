//
//  MockPLPhoneTopUpManagerProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SANPLLibrary
@testable import IDZSwiftCommonCrypto

final class MockPLPhoneTopUpManager: PLPhoneTopUpManagerProtocol {
    
    var getFormDataResult: Result<TopUpFormDataDTO, NetworkProviderError> = .failure(NetworkProviderError.other)
    
    var didCallGetFormData = false
    
    func getFormData() throws -> Result<TopUpFormDataDTO, NetworkProviderError> {
        didCallGetFormData = true
        return getFormDataResult
    }
    
    func checkPhone(request: CheckPhoneRequestDTO) throws -> Result<CheckPhoneResponseDTO, NetworkProviderError> {
        fatalError()
    }
    
    func reloadPhone(request: ReloadPhoneRequestDTO) throws -> Result<ReloadPhoneResponseDTO, NetworkProviderError> {
        fatalError()
    }
}
