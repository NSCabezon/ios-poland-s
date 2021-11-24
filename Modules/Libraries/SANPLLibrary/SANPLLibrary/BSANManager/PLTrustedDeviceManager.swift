//
//  PLTrustedDeviceManager.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 23/6/21.
//


public protocol PLTrustedDeviceManagerProtocol {
    func doBeforeLogin(_ parameters: BeforeLoginParameters) throws -> Result<BeforeLoginDTO, NetworkProviderError>
    func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError>
    func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError>
    func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError>
    func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError>
    func getDevices() throws -> Result<DevicesDTO, NetworkProviderError>
    func doConfirmRegistration(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError>
    func getPendingChallenge(_ parameters: PendingChallengeParameters) throws -> Result<PendingChallengeDTO, NetworkProviderError>
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getTrustedDeviceInfo(_ parameters: TrustedDeviceInfoParameters) throws -> Result<TrustedDeviceInfoDTO, NetworkProviderError>
    func deleteDeviceId()
    func storeDeviceId(_ deviceId: String)
    func getDeviceId() -> String?
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
    
    public func getPendingChallenge(_ parameters: PendingChallengeParameters) throws -> Result<PendingChallengeDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.getPendingChallenge(parameters)
    }
    
    public func doConfirmChallenge(_ parameters: ConfirmChallengeParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        return try trustedDeviceDataSource.doConfirmChallenge(parameters)
    }
    
    public func getTrustedDeviceInfo(_ parameters: TrustedDeviceInfoParameters) throws -> Result<TrustedDeviceInfoDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.getTrustedDeviceInfo(parameters)
    }
    
    public func doBeforeLogin(_ parameters: BeforeLoginParameters) throws -> Result<BeforeLoginDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.doBeforeLogin(parameters)
    }
    
    public func doRegisterDevice(_ parameters: RegisterDeviceParameters) throws -> Result<RegisterDeviceDTO, NetworkProviderError> {
        let result = try trustedDeviceDataSource.doRegisterDevice(parameters)
        return result
    }

    public func doRegisterSoftwareToken(_ parameters: RegisterSoftwareTokenParameters) throws -> Result<RegisterSoftwareTokenDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.doRegisterSoftwareToken(parameters)
    }
    
    public func doRegisterIvr(_ parameters: RegisterIvrParameters) throws -> Result<Data, NetworkProviderError> {
        return try trustedDeviceDataSource.doRegisterIvr(parameters)
    }
    
    public func doRegisterConfirmationCode(_ parameters: RegisterConfirmationCodeParameters) throws -> Result<Void, NetworkProviderError> {
        return try trustedDeviceDataSource.doRegisterConfirmationCode(parameters)
    }
    
    public func getDevices() throws -> Result<DevicesDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.getDevices()
    }

    public func doConfirmRegistration(_ parameters: RegisterConfirmParameters) throws -> Result<ConfirmRegistrationDTO, NetworkProviderError> {
        return try trustedDeviceDataSource.doRegisterConfirm(parameters)
    }

    public func getTrustedDeviceHeaders() -> TrustedDeviceHeaders? {
        return self.bsanDataProvider.getTrustedDeviceHeaders()
    }
    
    public func deleteTrustedDeviceHeaders() {
        return self.bsanDataProvider.deleteTrustedDeviceHeaders()
    }

    public func storeTrustedDeviceHeaders(_ headers: TrustedDeviceHeaders) {
        self.bsanDataProvider.storeTrustedDeviceHeaders(headers)
    }
    
    public func storeTrustedDeviceInfo(_ info: TrustedDeviceInfo) {
        self.bsanDataProvider.storeTrustedDeviceInfo(info)
    }
    
    public func getStoredTrustedDeviceInfo() -> TrustedDeviceInfo? {
        return self.bsanDataProvider.getTrustedDeviceInfo()
    }

    public func getEncryptedUserKeys() -> EncryptedUserKeys? {
        return self.bsanDataProvider.getEncryptedUserKeys()
    }

    public func deleteEncryptedUserKeys() {
        return self.bsanDataProvider.deleteEncryptedUserKeys()
    }

    public func storeEncryptedUserKeys(_ keys: EncryptedUserKeys) {
        self.bsanDataProvider.storeEncryptedUserKeys(keys)
    }
    
    public func deleteDeviceId() {
        bsanDataProvider.deleteDeviceId()
    }
    
    public func storeDeviceId(_ deviceId: String) {
        bsanDataProvider.storeDeviceId(deviceId)
    }
    
    public func getDeviceId() -> String? {
        bsanDataProvider.getDeviceId()
    }
}
