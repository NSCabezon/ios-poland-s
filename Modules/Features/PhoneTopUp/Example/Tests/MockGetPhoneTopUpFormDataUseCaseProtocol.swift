//
//  MockGetPhoneTopUpFormDataUseCaseProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CoreFoundationLib
@testable import PhoneTopUp

final class MockGetPhoneTopUpFormDataUseCase: UseCase<(), GetPhoneTopUpFormDataOutput, StringErrorOutput>, GetPhoneTopUpFormDataUseCaseProtocol {
    
    var result: UseCaseResponse<GetPhoneTopUpFormDataOutput, StringErrorOutput> = .error(.init("Error"))
    var didCallExecuteUseCase = false
    
    override func executeUseCase(requestValues: ()) throws -> UseCaseResponse<GetPhoneTopUpFormDataOutput, StringErrorOutput> {
        didCallExecuteUseCase = true
        return result
    }
}
