//
//  BSANLocalManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

final class BSANLocalManager {
    typealias JSON = [String: Any]
    private var userId: String = ""
    private var answerNumber: Int = 0
    private let demoInterpreter: DemoUserProtocol
    
    init(demoInterpreter: DemoUserProtocol) {
        self.demoInterpreter = demoInterpreter
        self.userId = demoInterpreter.demoUser
    }
}

extension BSANLocalManager: NetworkProvider {
    func requestData<Request>(_ request: Request) -> Result<Data, NetworkProviderError> where Request : NetworkProviderRequest {
        do {
            guard let stringToParse = try self.getJsonContentsFrom(serviceNameFile: request.localServiceName),
                  let jsonDictionary = try self.getJsonDictionary(from: Data(stringToParse.utf8)),
                  let answerElement = self.getAnswers(from: jsonDictionary, for: self.userId) else {
                return .failure(.other)
            }
            
            if let outputJSON = self.getJSON(from: answerElement, result: .success) {
                let data = try JSONSerialization.data(withJSONObject: outputJSON, options: .prettyPrinted)
                return .success(data)
            } else if let outputJSON = self.getJSON(from: answerElement, result: .error) {
                let error = outputJSON["errorCode"] as? Int ?? 500
                let data = try JSONSerialization.data(withJSONObject: outputJSON, options: .prettyPrinted)
                switch error {
                case 401:
                    return .failure(NetworkProviderError.unauthorized)
                case 422:
                    return .failure(NetworkProviderError.unprocessableEntity)
                default:
                    return .failure(NetworkProviderError.error(NetworkProviderResponseError(code: error, data: data, headerFields: nil, error: nil)))
                }
            } else if let data = self.getData(from: answerElement, result: self.demoInterpreter.expectedResponse) {
                return .success(data)
            } else {
                return .failure(.other)
            }
        } catch {
            return .failure(.other)
        }
    }
    
    func request<Request: NetworkProviderRequest, Response: Decodable>(_ request: Request) -> Result<Response, NetworkProviderError> {
        let response = self.requestData(request)
        return self.checkRequest(response)
    }
    
    func request<Request: NetworkProviderRequest>(_ request: Request) -> Result<Void, NetworkProviderError> {
        let response = self.requestData(request)
        switch response {
        case .success(_ ):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loginRequest<Request: NetworkProviderRequest, Response: Decodable>(_ request: Request) -> Result<Response, NetworkProviderError> {
        let response = self.requestData(request)
        return self.checkRequest(response)
    }
    
    func requestDataWithHeaders<Request>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> where Request : NetworkProviderRequest {
        let response = self.requestData(request)
        switch response {
        case .success(let data):
            let responseWithHeaders = NetworkProviderResponseWithHeaders(response: data,
                                                                         headers: ["Token-Request":""])
            return .success(responseWithHeaders)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func requestDataWithStatus<Request>(_ request: Request) -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> where Request : NetworkProviderRequest {
        let response = self.requestData(request)
        switch response {
        case .success(let data):
            return .success(NetworkProviderResponseWithStatus(data: data,
                                                              headers: [:],
                                                              statusCode: 200))
        case .failure(let error):
            return .failure(error)
        }
    }
    
}

// MARK: - Private Methods
private extension BSANLocalManager {
    func checkRequest<Response: Decodable>(_ response: Result<Data, NetworkProviderError>) -> Result<Response, NetworkProviderError> {
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
    
    func getJsonDictionary(from data: Data) throws -> [String: JSON]? {
        guard let jsonDictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: JSON]
        else {
            return nil
        }
        return jsonDictionary
    }
    
    func getJsonContentsFrom(serviceNameFile: PLLocalServiceName) throws -> String? {
        let testDestination = demoInterpreter.getDestinationFileFor(service: serviceNameFile)
        let bundle = testDestination.bundle ?? Bundle.module
        guard let filepath = bundle?.path(forResource: testDestination.file, ofType: "json") else {
            return nil
        }
        return try? String(contentsOfFile: filepath)
    }
    
    func getAnswers(from dictionary: [String: JSON], for demoId: String) -> (key: String, value: JSON)? {
        if let value = dictionary[demoId] {
            return (key: demoId, value: value)
        } else {
            return dictionary.filter({$0.key.lowercased() == self.userId.lowercased()}).first
        }
    }
    
    func getJSON(from element: (key: String, value: JSON), result: PLLocalAnswerType) -> JSON? {
        guard let value = element.value["\(result.rawValue)"] as? JSON else {
            return nil
        }
        return value
    }
    
    func getData(from element: (key: String, value: JSON), result: Int) -> Data? {
        guard let element = element.value["\(result)"] else { return nil }
        return try? JSONSerialization.data(withJSONObject: element, options: .prettyPrinted)
    }
}
