//
//  TrustedDeviceConfiguration.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 22/6/21.
//

public class TrustedDeviceConfiguration {

    var deviceData: DeviceData?
    var softwareToken: SoftwareToken?
    var deviceHeaders: DeviceHeaders?
    var loginPassword: String?

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
        let privateKey: SecKey?
        let certificatePEM: String?
    }

    struct DeviceHeaders {
        let encryptedParameters: String?
        let time: String?
        let appId: String
    }
}
