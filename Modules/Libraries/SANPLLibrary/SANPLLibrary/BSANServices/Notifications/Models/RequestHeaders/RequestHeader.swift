//
//  RequestHeader.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct RequestHeader: Codable {
    public let requestId: String
    public let timestamp: String?
    
    public init(requestId: String, timestamp: String?) {
        self.requestId = requestId
        self.timestamp = timestamp
    }
}
