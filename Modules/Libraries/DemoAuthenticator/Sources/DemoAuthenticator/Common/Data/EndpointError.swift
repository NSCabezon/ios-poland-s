//
//  EndpointError.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

enum EndpointError: LocalizedError {
    case selfDeallocated
    case urlCreationError
    case missingData
    case requestEncodingError
    case errorResponse(_ errorResponse: ErrorResponse)
}

extension EndpointError {
    var errorDescription: String? {
        switch self {
        case let .errorResponse(errorResponse):
            return errorResponse.errorDetail.map { errorDetail(from: $0) }.joined(separator: "\n")
        default:
            return localizedDescription
        }
    }

    private func errorDetail(from errorDetail: ErrorResponse.ErrorDetail) -> String {
        let dateTime = formatDateTime(date: errorDetail.errorTime)
        if let errorMessage = errorDetail.message {
            return "\(dateTime): \(errorMessage)"
        }

        return "\(dateTime): \(errorDetail.errorCode)"
    }
    
    private func formatDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
