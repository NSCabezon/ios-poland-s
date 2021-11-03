//
//  SmsAuthenticationEndpoint.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class SmsAuthenticationEndpoint {
    private let dataTaskRunner: DataTaskRunning

    init(dataTaskRunner: DataTaskRunning) {
        self.dataTaskRunner = dataTaskRunner
    }
}

extension SmsAuthenticationEndpoint: SmsAuthenticationEndpointProtocol {
    func authenticate(
        authHost: URL,
        smsAuthenticateRequest: SmsAuthenticateRequest,
        completion: @escaping (Result<SmsAuthenticateResponse, Swift.Error>) -> Void
    ) {
        let request: URLRequest
        do {
            request = try prepareRequest(
                authHost: authHost,
                smsAuthenticateRequest: smsAuthenticateRequest
            )
        } catch {
            completion(.failure(error))
            return
        }

        send(
            request: request,
            completion: completion
        )
    }

    private func prepareRequest(
        authHost: URL,
        smsAuthenticateRequest: SmsAuthenticateRequest
    ) throws -> URLRequest {
        let url = authHost.appendingPathComponent("api/as/authenticate")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(smsAuthenticateRequest)
        } catch {
            throw EndpointError.requestEncodingError
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    private func send(request: URLRequest, completion: @escaping (Result<SmsAuthenticateResponse, Swift.Error>) -> Void) {
        let task = dataTaskRunner.dataTask(with: request) { [weak self] data, response, error -> Void in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(EndpointError.missingData))
                return
            }

            guard let strongSelf = self else {
                completion(.failure(EndpointError.selfDeallocated))
                return
            }

            if
                let response = response as? HTTPURLResponse,
                response.statusCode >= 400 {
                strongSelf.handleErrorResponse(data: data, completion: completion)
                return
            }

            strongSelf.handleSuccessResponse(data: data, completion: completion)
        }

        task.resume()
    }

    private func handleSuccessResponse(data: Data, completion: @escaping (Result<SmsAuthenticateResponse, Swift.Error>) -> Void) {
        let smsAuthenticateResponse: SmsAuthenticateResponse
        do {
            smsAuthenticateResponse = try JSONDecoder().decode(SmsAuthenticateResponse.self, from: data)
        } catch {
            completion(.failure(error))
            return
        }

        completion(.success(smsAuthenticateResponse))
    }

    private func handleErrorResponse(data: Data, completion: @escaping (Result<SmsAuthenticateResponse, Swift.Error>) -> Void) {
        let errorResponse: ErrorResponse
        do {
            errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
        } catch {
            completion(.failure(error))
            return
        }

        completion(.failure(EndpointError.errorResponse(errorResponse)))
    }
}
