//
//  PLTrustedHeadersGenerator.swift
//  PLCryptography
//
//  Created by 187830 on 15/11/2021.
//

import CoreFoundationLib
import CoreFoundationLib
import CryptoSwift
import os
import SelfSignedCertificate
import SANLegacyLibrary
import SANPLLibrary

public class PLTrustedHeadersProvider: PLTrustedHeadersGenerable {
    
    private let dependenciesResolver: DependenciesResolver
    private lazy var managersProvider: PLManagersProviderProtocol = {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }()
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private lazy var deviceTimeFormater: DateFormatter = {
        let dateFormatterISO8601 = DateFormatter()
        dateFormatterISO8601.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatterISO8601
    }()
    
    private lazy var parametersTimeFormater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    public func getCurrentTrustedHeaders(
        with transactionParameters: TransactionParameters?,
        isTrustedDevice: Bool
    ) -> TrustedDeviceHeaders? {
        generateTrustedDeviceHeaders(
            transactionParameters: transactionParameters,
            isTrustedDevice: isTrustedDevice
        )
    }
    
    private func generateTrustedDeviceHeaders(transactionParameters: TransactionParameters?, isTrustedDevice: Bool) -> TrustedDeviceHeaders? {
        guard let key = SecIdentity.getSecIdentity(
            label: PLConstants.certificateIdentityLabel
        )?.privateKey else { return nil }
        let deviceData = generateDeviceData(transactionParameters: transactionParameters, isTrustedDevice: isTrustedDevice)
        guard let encryptedParameters = try? encryptParameters(deviceData.parameters, with: key) else { return nil }
        return TrustedDeviceHeaders(
            parameters: encryptedParameters,
            time: deviceData.deviceTime,
            appId: deviceData.appId
        )
    }
 
}

extension PLTrustedHeadersProvider {

    // parameters: string with parameters to encrypt (i.e. "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><Apple><model><iPhone 12>>")
    // key: key that will be use to encrypt parameters.
    public func encryptParameters(_ parameters: String, with key: SecKey) throws -> String {

        // Transform parameters into what we need before encrypting
        guard let bytesToEncrypt = Self.separateAndParciallyHashParameters(parameters: parameters) else {
            throw PLTrustedHeadersProviderErrorOutput.description("Error separating to encrypt")
        }

        guard let signedData = key.customSignWithoutHash(data: bytesToEncrypt)
        else { throw PLTrustedHeadersProviderErrorOutput.description("Error encrypting parameters") }

        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters to encrypt: %@", log: .default, type: .info, parameters)
        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters partially hashed: %@", log: .default, type: .info, Data(bytesToEncrypt).base64EncodedString())
        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters signed with private key: %@", log: .default, type: .info, Data(signedData).base64EncodedString())

        return Data(signedData).base64EncodedString()
    }
    
    // Having this string <2021-04-18 22:01:11.238><AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>
    // we need to separate in two strings:
    // prefix = <2021-04-18 22:01:11.238><AppId><1234567890abcdef12345678>
    // postfix = <deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>
    // and hash postfix with SHA256
    // Retuns concatenation of both arrays of bytes
    static func separateAndParciallyHashParameters(parameters: String) -> [UInt8]? {
        let nsString = parameters as NSString
        let range = nsString.range(of: "<deviceId>")
        guard range.length != 0 else { return nil }
        let prefix = parameters.substring(0, range.location)
        let postfix = parameters.substring(range.location, parameters.count)
        var concatenatedBytes: [UInt8] = Array()
        guard let prefixBytes = prefix?.bytes,
              let hashedPostfixBytes = postfix?.bytes.sha256() else {
            return nil
        }
        concatenatedBytes.append(contentsOf: prefixBytes)
        concatenatedBytes.append(contentsOf: hashedPostfixBytes)
        return concatenatedBytes
    }
}

extension SecKey {
   public func customSignWithoutHash(data:[UInt8]) -> [UInt8]? {
        var signature = [UInt8](repeating: 0, count: 1024)
        var signatureLength = 1024
        let status = SecKeyRawSign(self, .PKCS1, data, data.count, &signature, &signatureLength)
        guard status == errSecSuccess else {
            return nil
        }
        let realSignature = signature[0 ..< signatureLength]
        return Array(realSignature)
    }
}

// MARK: Generate Device Data
extension PLTrustedHeadersProvider {

    enum Constants {
        static let oneApp = "OneApp"
        static let manufacturer = "Apple"
        static let lastDeviceTime = "LastDeviceTime"
        static let lastParametersTime = "LastParametersTime"
        static let secondsForGenerateNewParameters = 60
    }

    public func generateDeviceData(transactionParameters: TransactionParameters? = nil, isTrustedDevice: Bool = false) -> DeviceData {
        let currentDate = Date()
        let currentDeviceTimeString = deviceTimeFormater.string(from: currentDate)
        let currentParametersTimeStrig = parametersTimeFormater.string(from: currentDate)
        let model = UIDevice.current.getDeviceName()
        let brand = Constants.manufacturer
        let deviceId = getDeviceId(isTrustedDevice: isTrustedDevice)
        let appId = Constants.oneApp + deviceId
        let manufacturer = Constants.manufacturer
        if let _ = transactionParameters {
            generateNewDevicesTimeAndSave(
                currentDeviceTime: currentDeviceTimeString,
                currentParametersTimeString: currentParametersTimeStrig
            )
        } else if shouldGenerateNewParamatersTime(currentDeviceTime: currentDeviceTimeString) {
            generateNewDevicesTimeAndSave(
                currentDeviceTime: currentDeviceTimeString,
                currentParametersTimeString: currentParametersTimeStrig
            )
        }
        
        let deviceTimeString = UserDefaults.standard.string(forKey: Constants.lastDeviceTime) ?? currentDeviceTimeString
        let dateParametersString = UserDefaults.standard.string(
            forKey: Constants.lastParametersTime
        ) ?? currentParametersTimeStrig
        
        let mainParameters = "<\(dateParametersString)><AppId><\(appId)><deviceId><\(deviceId)><manufacturer><\(manufacturer)><model><\(model)>"
        let parameters: String
        if let transactionParameters = transactionParameters {
            parameters = [
                mainParameters,
                transactionParameters.joinedParameters
            ].compactMap { $0 }.joined()
        } else {
            parameters = mainParameters
        }
        let deviceData = DeviceData(
            manufacturer: manufacturer,
            model: model,
            brand: brand,
            appId: appId,
            deviceId: deviceId,
            deviceTime: deviceTimeString,
            parameters: parameters
        )
        return deviceData
    }
    
    private func getDeviceId(isTrustedDevice: Bool) -> String {
        if isTrustedDevice, let deviceId = managersProvider.getTrustedDeviceManager().getDeviceId() {
            return deviceId
        }
        let newDeviceId = PLTrustedDeviceHelpers.secureRandom(bytesNumber: 9)?.toHexString() ?? ""
        managersProvider.getTrustedDeviceManager().storeDeviceId(newDeviceId)
        return newDeviceId
    }
    
    private func shouldGenerateNewParamatersTime(currentDeviceTime: String) -> Bool {
        guard let deviceTimeSaved = UserDefaults.standard.string(forKey: Constants.lastDeviceTime) else { return true }
        guard let deviceTimeSavedDate = deviceTimeFormater.date(from: deviceTimeSaved),
              let currentDeviceTimeDate = deviceTimeFormater.date(from: currentDeviceTime) else {
            return true
        }
        guard let elapsedTime = Calendar.current.dateComponents(
            [.second],
            from: deviceTimeSavedDate,
            to: currentDeviceTimeDate
        ).second else {
            return true
        }
        if elapsedTime < Constants.secondsForGenerateNewParameters {
            return false
        }
        return true
    }
        
    private func generateNewDevicesTimeAndSave(currentDeviceTime: String, currentParametersTimeString: String) {
        UserDefaults.standard.setValue(currentDeviceTime, forKey: Constants.lastDeviceTime)
        UserDefaults.standard.setValue(currentParametersTimeString, forKey: Constants.lastParametersTime)
    }
}

enum PLTrustedHeadersProviderErrorOutput: Error {
    case description(String)
}
