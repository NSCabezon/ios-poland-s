//
//  TrustedDeviceConfiguration.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 22/6/21.
//

public struct TrustedDeviceConfiguration {

    let deviceData: DeviceData
    var softwareToken: SoftwareToken?

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
}
