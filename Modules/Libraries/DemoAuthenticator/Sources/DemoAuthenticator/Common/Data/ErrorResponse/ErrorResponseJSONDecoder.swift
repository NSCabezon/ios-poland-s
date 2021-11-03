//
//  ErrorResponseJSONDecoder.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 22/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

final class ErrorResponseJSONDecoder {
    private let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
}

extension ErrorResponseJSONDecoder: ErrorResponseDecoding {
    func decode(data: Data) throws -> ErrorResponse {
        return try jsonDecoder.decode(ErrorResponse.self, from: data)
    }
}
