//
//  PubKeyEndpoint.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class PubKeyEndpoint {
    private let dataTaskRunner: DataTaskRunning

    init(dataTaskRunner: DataTaskRunning) {
        self.dataTaskRunner = dataTaskRunner
    }
}

extension PubKeyEndpoint: PubKeyEndpointProtocol {
    func pubKey(
        authHost: URL,
        completion: @escaping (Result<PubKey, Swift.Error>) -> Void
    ) {
        let request: URLRequest
        do {
            request = try prepareRequest(
                authHost: authHost
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
        authHost: URL
    ) throws -> URLRequest {
        let url = authHost.appendingPathComponent("api/as/pub_key")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    private func send(request: URLRequest, completion: @escaping (Result<PubKey, Swift.Error>) -> Void) {
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

    private func handleSuccessResponse(data: Data, completion: @escaping (Result<PubKey, Swift.Error>) -> Void) {
        let pubKey: PubKey
        do {
            pubKey = try JSONDecoder().decode(PubKey.self, from: data)
        } catch {
            completion(.failure(error))
            return
        }

        completion(.success(pubKey))
    }

    private func handleErrorResponse(data: Data, completion: @escaping (Result<PubKey, Swift.Error>) -> Void) {
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
