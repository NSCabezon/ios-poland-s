//
//  MockCheckPhoneUseCase.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 15/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CoreFoundationLib
@testable import PhoneTopUp

final class MockCheckPhoneUseCase: UseCase<CheckPhoneUseCaseInput, CheckPhoneUseCaseOutput, StringErrorOutput>, CheckPhoneUseCaseProtocol {
    
    var result: UseCaseResponse<CheckPhoneUseCaseOutput, StringErrorOutput> = .error(.init("error"))
    
    override func executeUseCase(requestValues: CheckPhoneUseCaseInput) throws -> UseCaseResponse<CheckPhoneUseCaseOutput, StringErrorOutput> {
        return result
    }
}
