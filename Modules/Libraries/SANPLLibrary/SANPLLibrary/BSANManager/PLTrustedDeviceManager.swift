//
//  PLTrustedDeviceManager.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//

import Foundation

public protocol PLTrustedDeviceManagerProtocol {
    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError>
    func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError>
    func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError>
    func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError>
    func getDevices() throws -> Result<DevicesDTO, NetworkProviderError>
    func doConfirmRegistration(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError>
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

    public func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterSoftwareToken(parameters)
        return result
    }
    
    public func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterIvr(parameters)
        return result
    }
    
    public func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterConfirmationCode(parameters)
        return result
    }
    
    public func getDevices() throws -> Result<DevicesDTO, NetworkProviderError> {
        let result = try trustedDeviceDataSource.getDevices()
        return result
    }

    public func doConfirmRegistration(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterConfirm(parameters)
        return result
    }

    public func getTrustedDeviceHeaders() -> TrustedDeviceHeaders? {
        return self.bsanDataProvider.getTrustedDeviceHeaders()
    }

    public func storeTrustedDeviceHeaders(_ headers: TrustedDeviceHeaders) {
        self.bsanDataProvider.storeTrustedDeviceHeaders(headers)
    }
}
