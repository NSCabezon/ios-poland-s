//
//  MockTopUpSettings.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension TopUpSettings {
    static func mockInstance() -> TopUpSettings {
        return [TopUpOperatorSettings.mockInstance()]
    }
}
