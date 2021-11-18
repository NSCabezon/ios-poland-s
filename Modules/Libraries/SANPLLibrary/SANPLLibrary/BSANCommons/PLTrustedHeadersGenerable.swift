//
//  PLTrustedHeadersGenerable.swift
//  SANPLLibrary
//
//  Created by 187830 on 17/11/2021.
//

public protocol PLTrustedHeadersGenerable {
    func getCurrentTrustedHeaders(
        with transactionParameters: TransactionParameters?,
        isTrustedDevice: Bool
    ) -> TrustedDeviceHeaders?
    func encryptParameters(_ parameters: String, with key: SecKey) throws -> String
    func generateDeviceData(transactionParameters: TransactionParameters?, isTrustedDevice: Bool) -> DeviceData
}
