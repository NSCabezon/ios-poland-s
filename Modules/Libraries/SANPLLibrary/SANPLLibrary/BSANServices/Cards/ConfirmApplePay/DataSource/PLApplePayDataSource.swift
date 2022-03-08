//
//  PLApplePayDataSource.swift
//  Account
//
//  Created by 188454 on 18/02/2022.
//

import Foundation
import SANLegacyLibrary

protocol PLApplePayDataSourceProtocol {
    func confirmApplePay(virtualPan: String?,
                         publicCertificates: [Data],
                         nonce: Data,
                         nonceSignature: Data) throws -> Result<PLApplePayConfirmationDTO, NetworkProviderError>
}

final class PLApplePayDataSource: PLApplePayDataSourceProtocol {
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private var headers: [String: String] = [:]
    private var queryParams: [String: Any]? = nil

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func confirmApplePay(virtualPan: String?,
                         publicCertificates: [Data],
                         nonce: Data,
                         nonceSignature: Data) throws -> Result<PLApplePayConfirmationDTO, NetworkProviderError> {

        guard let vpan = virtualPan else {
            print("virtual PAN is nil")
            return .failure(.other)
        }

        self.queryParams = ["vpan" : vpan]
        
        let parameters = ApplePayConfirmationParameters(
            certificates: publicCertificates.map { $0.toHexString() },
            encryptDataApple: EncryptDataAppleDTO(nonce: nonce.toHexString(),
                                                  nonceSignature: nonceSignature.toHexString()))

        guard let baseUrl = self.getBaseUrl()?.replace("/oneapp", "") else {
            return .failure(NetworkProviderError.other)
        }

        let request = PLApplePayRequest(serviceName: "/cortex/api/pushProv/apple",
                                        serviceUrl: baseUrl,
                                        method: .post,
                                        body: nil,
                                        jsonBody: parameters,
                                        bodyEncoding: .body,
                                        headers: self.headers,
                                        queryParams: self.queryParams,
                                        contentType: .json,
                                        localServiceName: .applePayConfirmation)
        let result: Result<PLApplePayConfirmationDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
}

private extension PLApplePayDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

private struct PLApplePayRequest: NetworkProviderRequest {

    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: ApplePayConfirmationParameters?
    let formData: Data?
    var bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String = "",
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: ApplePayConfirmationParameters?,
         bodyEncoding: NetworkProviderBodyEncoding?,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.jsonBody = jsonBody
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.bodyEncoding = bodyEncoding
        self.localServiceName = localServiceName
    }
}
public struct ApplePayConfirmationParameters: Codable {
    public let certificates: [String]
    public let encryptDataApple: EncryptDataAppleDTO
    
    public init(certificates: [String], encryptDataApple: EncryptDataAppleDTO) {
        self.certificates = certificates
        self.encryptDataApple = encryptDataApple
    }
}
