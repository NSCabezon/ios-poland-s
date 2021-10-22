//
//  TrustedDeviceConfiguration.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 22/6/21.
//
import SANPLLibrary

public class TrustedDeviceConfiguration {

    var deviceData: DeviceData?
    var softwareToken: SoftwareToken?
    var deviceHeaders: DeviceHeaders?
    var loginPassword: String?
    var tokens: [TrustedDeviceSoftwareToken]?
    var ivrOutputCode: Int?
    var trustedDevice: TrustedDevice?
    var registrationConfirm: RegistrationConfirm?

    struct DeviceData {
        let manufacturer: String
        let model: String
        let brand: String
        let appId: String
        let deviceId: String
        let deviceTime: String
        let parameters: String
    }

    struct SoftwareToken {
        let identity: SecIdentity?
    }

    struct DeviceHeaders {
        let encryptedParameters: String
        let time: String
        let appId: String
    }

    struct TrustedDevice {
        let trustedDeviceId: Int
        let userId: Int
        let trustedDeviceState: String
        let trustedDeviceTimestamp: Int
        let ivrInputCode: Int
    }

    struct RegistrationConfirm {
        let id: Int
        let state: String
        let badTriesCount: Int
        let triesAllowed: Int
        let timestamp: Int
        let name: String?
        let key: String?
        let type: String?
        let trustedDeviceId: Int?
        let dateOfLastStatusChange: String?
        let properUseCount: Int?
        let badUseCount: Int?
        let dateOfLastProperUse: String?
        let dateOfLastBadUse: String?
    }
}
