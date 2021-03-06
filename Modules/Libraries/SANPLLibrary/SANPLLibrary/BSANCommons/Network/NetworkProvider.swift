//
//  NetworkProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//


// MARK: - NetworkProvider

public protocol NetworkProvider {
    func request<Request: NetworkProviderRequest, Response: Decodable>(_ request: Request) -> Result<Response, NetworkProviderError>
    func request<Request: NetworkProviderRequest>(_ request: Request) -> Result<Void, NetworkProviderError>
    func requestData<Request: NetworkProviderRequest>(_ request: Request) -> Result<Data, NetworkProviderError>
    func requestDataWithHeaders<Request: NetworkProviderRequest>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError>
    func requestDataWithStatus<Request: NetworkProviderRequest>(_ request: Request) -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
}

// MARK: - NetworkProviderRequest

public protocol NetworkProviderRequest {
    associatedtype Body: Encodable
    var serviceName: String { get }
    var localServiceName: PLLocalServiceName { get }
    var method: NetworkProviderMethod { get }
    var serviceUrl: String { get }
    var headers: [String: String]? { get }
    var queryParams: [String: Any]? { get }
    var jsonBody: Body? { get }
    var formData: Data? { get }
    var bodyEncoding: NetworkProviderBodyEncoding? { get }
    var contentType: NetworkProviderContentType? { get }
    var authorization: NetworkProviderRequestAuthorization? { get }
}

struct NetworkProviderRequestBodyEmpty: Encodable {}

public enum NetworkProviderRequestAuthorization {
    case oauth
    case trustedDeviceOnly
    case twoFactorOperation(transactionParameters: TransactionParameters?)
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
    case pdf = "pdf"
}

// MARK: - NetworkProviderError

public enum NetworkProviderError: LocalizedError {
    case error(_ error: NetworkProviderResponseError)
    case unauthorized
    case other
    case noConnection
    case unprocessableEntity
    case maintenance
    
    public func getErrorBody<T: Codable>() -> T? {
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
    
    public init(code: Int, data: Data?, headerFields: [AnyHashable:Any]?, error: Error?) {
        self.code = code
        self.data = data
        self.headerFields = headerFields
        self.error = error
    }
    
    public func getErrorDetail() -> PLResponseErrorDetail? {
        guard let data = self.data else { return nil }
        guard let dto: PLResponseError = try? JSONDecoder().decode(PLResponseError.self, from: data) else {
            return nil
        }
        return dto.errorDetail.first
   }
}

public struct PLResponseError: Decodable {
    public let errorDetail:[PLResponseErrorDetail]
}

public struct PLResponseErrorDetail: Decodable {
    public let errorCode, message, errorTime: String
}

private extension NetworkProviderError {
    func getErrorBody() -> Data? {
        guard case .error(let error) = self,
              let body = error.data else {
            return nil
        }
        return body
    }
    
    func createBodyError<T: Codable>(_ body: Data) -> T? {
        return decodeError(body)
    }
    
    func decodeError<T: Codable>(_ data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - NetworkProviderResponseWithHeader
public struct NetworkProviderResponseWithHeaders {
    let response: Data
    let headers: [AnyHashable: Any]
}

public struct NetworkProviderResponseWithStatus {
    let data: Data?
    let headers: [AnyHashable: Any]
    let statusCode: Int
}
