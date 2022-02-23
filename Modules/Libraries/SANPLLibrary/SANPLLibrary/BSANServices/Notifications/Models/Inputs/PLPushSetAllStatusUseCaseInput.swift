//
//  PLPushSetAllStatusUseCaseInput.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLPushSetAllStatusUseCaseInput: Encodable {
    let requestHeader: RequestHeader = RequestHeader(requestId: UUID().uuidString, timestamp: nil)
    let deviceId: Int?
    let status: String = "read"
    let categories: [String?]

    public init(deviceId: Int?, categories: [String?]) {
        self.deviceId = deviceId
        self.categories = categories
    }
}

