//
//  URLSessionNetworkProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public final class URLSessionNetworkProvider {
    private let dataProvider: BSANDataProvider
    private let urlSession: URLSession
    
    public init(dataProvider: BSANDataProvider, isTrustInvalidCertificateEnabled: Bool) {
        self.dataProvider = dataProvider
        self.urlSession = URLSession(configuration: .default, delegate: URLSessionPinningDelegate(isTrustInvalidCertificateEnabled: isTrustInvalidCertificateEnabled), delegateQueue: nil)
    }
}

private extension URLSessionNetworkProvider {
    private var isDemo: Bool { return true }
    
    func createRequest<Request: NetworkProviderRequest>(_ request: Request) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: request.serviceUrl) else {
            throw NetworkProviderError.other
        }
        if let queryParams = request.queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw NetworkProviderError.other
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        try self.addHeaders(&urlRequest, request: request)
        switch request.bodyEncoding {
        case .body:
            let data = try JSONEncoder().encode(request.jsonBody)
            urlRequest.httpBody = data
        case .form:
            urlRequest.httpBody = request.formData
        case .none:
            break
        }
        return urlRequest
    }
    
    //TODO: Review headers values
    func addHeaders<Request: NetworkProviderRequest>(_ urlRequest: inout URLRequest, request: Request) throws {
        request.headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        if let clientId = try? dataProvider.getEnvironment().clientId,
           urlRequest.value(forHTTPHeaderField: "client-id") == nil
           {
            urlRequest.addValue(clientId, forHTTPHeaderField: "Client-id")
        }
        urlRequest.addValue("application/\(request.contentType.rawValue)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Santander PL ONE App", forHTTPHeaderField: "User-Agent")
        let traceUUID = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        let spanUUID = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16).lowercased()
        urlRequest.addValue(traceUUID, forHTTPHeaderField: "X-B3-TraceId")
        urlRequest.addValue(spanUUID, forHTTPHeaderField: "X-B3-SpanId")
        urlRequest.addValue("1", forHTTPHeaderField: "X-B3-Sampled")
        switch request.authorization {
        case .oauth:
            try self.addOauthAuthorization(&urlRequest)
        case .none:
            break
        }
    }
    
    func addOauthAuthorization(_ urlRequest: inout URLRequest) throws {
        // TODO: Fill with auth info
//        let authCredentials = try self.dataProvider.getAuthCredentials()
//        guard let accessToken = authCredentials.oAuthCredentials?.accessToken else {
//            throw NetworkProviderError.other
//        }
//        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    func executeUrlRequest(_ urlRequest: URLRequest) -> Result<Data, NetworkProviderError> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Data, NetworkProviderError> = .failure(NetworkProviderError.other)
        self.urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            result = self.checkResponse(data, response, error)
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return result
    }
    
    func checkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Data, NetworkProviderError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkProviderError.noConnection)
        }
        let statusCode = httpResponse.statusCode
        switch httpResponse.statusCode {
        case 204:
            return .success(Data())
        case 200...203, 205...299:
            guard let data = data else {
                return .failure(NetworkProviderError.other)
            }
            return .success(data)
        case 401:
            return .failure(NetworkProviderError.unauthorized)
        default:
            let error = NetworkProviderResponseError(code: statusCode,
                                                data: data,
                                                headerFields: httpResponse.allHeaderFields,
                                                error: error)
            return .failure(NetworkProviderError.error(error))
        }
    }
    
    func checkResponseWithHeaders(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkProviderError.noConnection)
        }
        let statusCode = httpResponse.statusCode
        switch httpResponse.statusCode {
        case 200...299:
            guard let data = data else {
                return .failure(NetworkProviderError.other)
            }
            return .success(NetworkProviderResponseWithHeaders(response: data, headers: httpResponse.allHeaderFields))
        case 401:
            return .failure(NetworkProviderError.unauthorized)
        default:
            let error = NetworkProviderResponseError(code: statusCode,
                                                data: data,
                                                headerFields: httpResponse.allHeaderFields,
                                                error: error)
            return .failure(NetworkProviderError.error(error))
        }
    }
    
    func checkResponseWithStatus(_ data: Data?,
                                       _ response: URLResponse?,
                                       _ error: Error?) -> Result<NetworkProviderResponseWithStatus,
                                                                  NetworkProviderError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkProviderError.noConnection)
        }
        let statusCode = httpResponse.statusCode
        switch httpResponse.statusCode {
        case 200...299:
            return .success(NetworkProviderResponseWithStatus(data: data,
                                                              headers: httpResponse.allHeaderFields,
                                                              statusCode: httpResponse.statusCode))
        case 401:
            return .failure(NetworkProviderError.unauthorized)
        default:
            let error = NetworkProviderResponseError(code: statusCode,
                                                data: data,
                                                headerFields: httpResponse.allHeaderFields,
                                                error: error)
            return .failure(NetworkProviderError.error(error))
        }
    }
    
    func executeUrlRequestWithHeaders(_ urlRequest: URLRequest) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<NetworkProviderResponseWithHeaders, NetworkProviderError> = .failure(NetworkProviderError.other)
        self.urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            result = self.checkResponseWithHeaders(data, response, error)
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return result
    }
    
    func executeUrlRequestWithStatus(_ urlRequest: URLRequest) -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<NetworkProviderResponseWithStatus, NetworkProviderError> = .failure(NetworkProviderError.other)
        self.urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            result = self.checkResponseWithStatus(data, response, error)
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return result
    }
    
    func checkRequestDataResponse<Response: Decodable>(_ response: Result<Data, NetworkProviderError>) -> Result<Response, NetworkProviderError> {
        switch response {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                return .success(result)
            } catch {
                return .failure(NetworkProviderError.error(NetworkProviderResponseError(code: 0, data: data, headerFields: nil, error: error)))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension URLSessionNetworkProvider: NetworkProvider {
    public func request<Request: NetworkProviderRequest, Response: Decodable>(_ request: Request) -> Result<Response, NetworkProviderError> {
        let response = self.requestData(request)
        return self.checkRequestDataResponse(response)
    }
    
    public func request<Request: NetworkProviderRequest>(_ request: Request) -> Result<Void, NetworkProviderError> {
        let response = self.requestData(request)
        switch response {
        case .success(_ ):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func requestData<Request: NetworkProviderRequest>(_ request: Request) -> Result<Data, NetworkProviderError> {
        do {
            let urlRequest = try self.createRequest(request)
            let response = self.executeUrlRequest(urlRequest)
            return response
        } catch let error as NetworkProviderError {
            return .failure(error)
        } catch {
            return .failure(.other)
        }
    }
    
    public func requestDataWithHeaders<Request: NetworkProviderRequest>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> {
        do {
            let urlRequest = try self.createRequest(request)
            let response = self.executeUrlRequestWithHeaders(urlRequest)
            switch response {
            case .success(let responseWithHeaders):
                return .success(responseWithHeaders)
            case .failure(let error):
                return .failure(error)
            }
        } catch let error as NetworkProviderError {
            return .failure(error)
        } catch {
            return .failure(.other)
        }
    }
    
    public func requestDataWithStatus<Request: NetworkProviderRequest>(_ request: Request) -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        do {
            let urlRequest = try self.createRequest(request)
            let response = self.executeUrlRequestWithStatus(urlRequest)
            switch response {
            case .success(let response):
                return .success(response)
            case .failure(let error):
                return .failure(error)
            }
        } catch let error as NetworkProviderError {
            return .failure(error)
        } catch {
            return .failure(.other)
        }
    }
}
