//
//  DataTaskRunner.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class DataTaskRunner {
    private let urlSession: URLSession
    private let logger: Logger?

    init(
        urlSession: URLSession = URLSession.shared,
        logger: Logger? = nil
    ) {
        self.urlSession = urlSession
        self.logger = logger
    }
}

extension DataTaskRunner: DataTaskRunning {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let uuid = UUID().uuidString
        logRequest(id: uuid, request: request)
        return urlSession.dataTask(with: request) { [weak self] data, response, error in
            self?.logResponse(id: uuid, data: data, response: response, error: error)
            completionHandler(data, response, error)
        }
    }
    
    private func logRequest(id: String, request: URLRequest) {
        logger?.info {
            if let url = request.url {
                return "[\(id)] Request URL: \(url.absoluteString)"
            }
            return nil
        }
        logger?.info {
            if
                let httpBody = request.httpBody,
                let json = String(data: httpBody, encoding: .utf8) {
                return "[\(id)] Request body: \(json)"
            }
            return nil
        }
    }
    
    private func logResponse(id: String, data: Data?, response: URLResponse?, error: Error?) {
        logger?.info {
            if let error = error {
                return "[\(id)] Error: \(error.localizedDescription)"
            }
            if
                let data = data,
                let json = String(data: data, encoding: .utf8) {
                return "[\(id)] Response body: \(json)"
            }
            return nil
        }
    }
}
