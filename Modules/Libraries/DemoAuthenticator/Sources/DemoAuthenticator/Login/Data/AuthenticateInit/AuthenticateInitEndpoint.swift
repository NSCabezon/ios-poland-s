//
//  AuthenticateInitEndpoint.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class AuthenticateInitEndpoint {
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

extension AuthenticateInitEndpoint: AuthenticateInitEndpointProtocol {
    func authenticateInit(
        authHost: URL,
        authenticateInitRequest: AuthenticateInitRequest,
        completion: @escaping (Result<Void, Swift.Error>) -> Void
    ) {
        let request: URLRequest
        do {
            request = try prepareRequest(
                authHost: authHost,
                authenticateInitRequest: authenticateInitRequest
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
        authenticateInitRequest: AuthenticateInitRequest
    ) throws -> URLRequest {
        let url = authHost.appendingPathComponent("api/as/authenticate/init")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(authenticateInitRequest)
        } catch {
            throw EndpointError.requestEncodingError
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    private func send(request: URLRequest, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
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

    private func handleSuccessResponse(data: Data, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
        completion(.success(()))
    }

    private func handleErrorResponse(data: Data, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
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
