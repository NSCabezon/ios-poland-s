//
//  MockMobileContact.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
@testable import PhoneTopUp

extension MobileContact {
    static func mockInstance(phoneNumber: String = "506738473") -> MobileContact {
        return MobileContact(fullName: "John Doe",
                             phoneNumber: phoneNumber)
    }
}
