//
//  LoginInitEndpoint.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class LoginInitEndpoint {
    private let dataTaskRunner: DataTaskRunning
    private let errorResponseDecoder: ErrorResponseDecoding

    init(
        dataTaskRunner: DataTaskRunning,
        errorResponseDecoder: ErrorResponseDecoding
    ) {
        self.dataTaskRunner = dataTaskRunner
        self.errorResponseDecoder = errorResponseDecoder
    }
}

extension LoginInitEndpoint: LoginInitEndpointProtocol {
    func login(
        authHost: URL,
        loginInfoRequest: LoginInfoRequest,
        completion: @escaping (Result<LoginInfoResponse, Swift.Error>) -> Void
    ) {
        let request: URLRequest
        do {
            request = try prepareRequest(
                authHost: authHost,
                loginInfoRequest: loginInfoRequest
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
        loginInfoRequest: LoginInfoRequest
    ) throws -> URLRequest {
        let url = authHost.appendingPathComponent("api/as/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(loginInfoRequest)
        } catch {
            throw EndpointError.requestEncodingError
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    private func send(request: URLRequest, completion: @escaping (Result<LoginInfoResponse, Swift.Error>) -> Void) {
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

    private func handleSuccessResponse(data: Data, completion: @escaping (Result<LoginInfoResponse, Swift.Error>) -> Void) {
        let loginInfoResponse: LoginInfoResponse
        do {
            loginInfoResponse = try JSONDecoder().decode(LoginInfoResponse.self, from: data)
        } catch {
            completion(.failure(error))
            return
        }

        completion(.success(loginInfoResponse))
    }

    private func handleErrorResponse(data: Data, completion: @escaping (Result<LoginInfoResponse, Swift.Error>) -> Void) {
        let errorResponse: ErrorResponse
        do {
            errorResponse = try errorResponseDecoder.decode(data: data)
        } catch {
            completion(.failure(error))
            return
        }

        completion(.failure(EndpointError.errorResponse(errorResponse)))
    }
}
