//
//  TopUpValuesMock.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension TopUpValues {
    static func mockInstance() -> TopUpValues {
        return TopUpValues(type: "0",
                           min: 5,
                           max: 500,
                           values: [
                            TopUpValue(value: 5, bonus: 0),
                            TopUpValue(value: 10, bonus: 0),
                            TopUpValue(value: 50, bonus: 5),
                            TopUpValue(value: 100, bonus: 10),
                           ])
    }
}
