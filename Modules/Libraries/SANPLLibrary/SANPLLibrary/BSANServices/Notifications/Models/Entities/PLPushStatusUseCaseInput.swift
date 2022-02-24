//
//  PLPushStatusUseCaseInput.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLPushStatusUseCaseInput: Codable {
    public let requestHeader: RequestHeader
    public let pushList: [PLPushStatus]
    public let loginId: Int?
    
    public init(
        requestHeader: RequestHeader = RequestHeader(requestId: UUID().uuidString, timestamp: nil),
        pushList: [PLPushStatus],
        loginId: Int?) {
        self.requestHeader = requestHeader
        self.pushList = pushList
        self.loginId = loginId
    }
}
