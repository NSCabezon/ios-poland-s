//
//  PLTrustedHeadersProviderMock.swift
//  SANPLLibrary_Tests
//
//  Created by 187830 on 17/11/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SANPLLibrary

final class PLTrustedHeadersProviderMock: PLTrustedHeadersGenerable {
    func getCurrentTrustedHeaders(with transactionParameters: TransactionParameters?, isTrustedDevice: Bool) -> TrustedDeviceHeaders? {
        fatalError()
    }
    
    func encryptParameters(_ parameters: String, with key: SecKey) throws -> String {
        fatalError()
    }
    
    func generateDeviceData(transactionParameters: TransactionParameters?, isTrustedDevice: Bool) -> DeviceData {
        fatalError()
    }
}
