//
//  NetworkProvider.swift
//  SANPTLibrary
//
//  Created by Jose Ignacio de Juan Díaz on 23/12/2020.
//

import Foundation

// MARK: - NetworkProvider

public protocol NetworkProvider {
    func request<Request: NetworkProviderRequest, Response: Decodable>(_ request: Request) -> Result<Response, NetworkProviderError>
    func requestData<Request: NetworkProviderRequest>(_ request: Request) -> Result<Data, NetworkProviderError>
    func requestDataWithHeaders<Request: NetworkProviderRequest>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError>
}

// MARK: - NetworkProviderRequest

public protocol NetworkProviderRequest {
    associatedtype Body: Encodable
    var serviceName: String { get }
    var localServiceName: PTLocalServiceName { get }
    var method: NetworkProviderMethod { get }
    var serviceUrl: String { get }
    var headers: [String: String]? { get }
    var queryParams: [String: String]? { get }
    var jsonBody: Body? { get }
    var formData: Data? { get }
    var bodyEncoding: NetworkProviderBodyEncoding? { get }
    var contentType: NetworkProviderContentType { get }
    var authorization: NetworkProviderRequestAuthorization? { get }
}

struct NetworkProviderRequestBodyEmpty: Encodable {}

public enum NetworkProviderRequestAuthorization {
    case oauth
}

public enum NetworkProviderBodyEncoding {
    case body
    case form
}

public enum NetworkProviderMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkProviderContentType : String {
    case urlEncoded = "x-www-form-urlencoded"
    case json = "json"
    case queryString = "query"
}

// MARK: - NetworkProviderError

public enum NetworkProviderError: Error {
    case error(_ error: NetworkProviderResponseError)
    case unauthorized
    case other
    
    public func getErrorBody<ErrorDTO: Codable>() -> ErrorDTO? {
        guard let body = self.getErrorBody() else {
            return nil
        }
        return self.createBodyError(body)
    }
    
    public func getErrorCode() -> Int? {
        guard case .error(let error) = self else {
            return nil
        }
        return error.code
    }
    
    public func getErrorHeaders() -> [AnyHashable: Any]? {
        guard case .error(let error) = self,
              let headers = error.headerFields else { return nil }
        return headers
    }
}

public struct NetworkProviderResponseError {
    let code: Int
    let data: Data?
    let headerFields: [AnyHashable: Any]?
    let error: Error?
}

private extension NetworkProviderError {
    func getErrorBody() -> Data? {
        guard case .error(let error) = self,
              let body = error.data else {
            return nil
        }
        return body
    }
    
    func createBodyError<ErrorDTO: Codable>(_ body: Data) ->  ErrorDTO? {
        guard let decodedError: ErrorDTO? = self.decodeError(body),
              let errorDTO = decodedError else { return nil }
        return errorDTO
    }
    
    func decodeError<ErrorDTO: Codable>(_ data: Data) -> ErrorDTO? {
        return try? JSONDecoder().decode(ErrorDTO.self, from: data)
    }
}

// MARK: - NetworkProviderResponseWithHeader
public struct NetworkProviderResponseWithHeaders {
    let response: Data
    let headers: [AnyHashable: Any]
}