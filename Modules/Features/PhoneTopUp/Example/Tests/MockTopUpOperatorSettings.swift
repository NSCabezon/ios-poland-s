//
//  MockTopUpOperatorSettings.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension TopUpOperatorSettings {
    static func mockInstance() -> TopUpOperatorSettings {
        TopUpOperatorSettings(operatorId: 0,
                              defaultTopUpValue: 10,
                              requestAcceptance: false)
    }
}
