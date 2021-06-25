//
//  PLTrustedDeviceManager.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Foundation

public protocol PLTrustedDeviceManagerProtocol {
    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError>
}

public final class PLTrustedDeviceManager {
    private let trustedDeviceDataSource: TrustDeviceDataSource
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.trustedDeviceDataSource = TrustDeviceDataSource(networkProvider: networkProvider,
                                                             dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLTrustedDeviceManager: PLTrustedDeviceManagerProtocol {
    public func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterDevice(parameters)
        return result
    }
}
