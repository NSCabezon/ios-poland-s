//
//  MockGSM]Operator.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension GSMOperator {
    static func mockInstance() -> GSMOperator {
        return GSMOperator(id: 0, blueMediaId: "0", name: "Orange")
    }
}
