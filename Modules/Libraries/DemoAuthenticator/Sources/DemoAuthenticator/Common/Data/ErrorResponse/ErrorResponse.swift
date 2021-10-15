//
//  ErrorResponse.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorDetail: [ErrorResponse.ErrorDetail]

    struct ErrorDetail: Decodable {
        let errorCode: ErrorResponse.ErrorDetail.ErrorCode
        let errorTime: Date
        let message: String?

        enum ErrorCode: String, Decodable {
            case serverError = "SERVER_ERROR"
            case invalidRequest = "INVALID_REQUEST"
            case unauthorizedGrant = "UNAUTHORIZED_GRANT"
            case invalidClientId = "INVALID_CLIENT_ID"
            case invalidGrant = "INVALID_GRANT"
            case unsupportedGrant = "UNSUPPORTED_GRANT"
            case invalidRedirectUri = "INVALID_REDIRECT_URI"
            case unauthorizedToken = "UNAUTHORIZED_TOKEN"
            case unsupportedResponseType = "UNSUPPORTED_RESPONSE_TYPE"
            case invalidScope = "INVALID_SCOPE"
        }
    }
}
