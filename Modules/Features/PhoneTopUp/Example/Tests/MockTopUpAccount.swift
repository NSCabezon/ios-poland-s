//
//  MockTopUpAccount.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 09/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

extension TopUpAccount {
    static func mockInstance() -> TopUpAccount {
        return TopUpAccount(number: "1234567899", name: "Konto godne polecenia")
    }
}
