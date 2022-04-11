//
//  MockOperator.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension Operator {
    static func mockInstance() -> Operator {
        return Operator(id: 0,
                        name: "Orange",
                        topupValues: TopUpValues.mockInstance(),
                        prefixes: ["506"])
    }
}
