//
//  MockGetContactsUseCase.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 14/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
import CoreFoundationLib
@testable import PhoneTopUp

final class MockGetContactsUseCase: UseCase<Void, GetContactsUseCaseOutput, StringErrorOutput>, GetContactsUseCaseProtocol {
    
    var result: UseCaseResponse<GetContactsUseCaseOutput, StringErrorOutput> = .error(.init("error"))
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetContactsUseCaseOutput, StringErrorOutput> {
        return result
    }
}
