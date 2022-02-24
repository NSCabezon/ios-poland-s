//
//  PLPushStatus.swift
//  SANPLLibrary
//
//  Created by 188454 on 18/01/2022.
//

public struct PLPushStatus: Codable {
    public let id: Int
    public let status: String
    
    public init(id: Int, status: String) {
        self.id = id
        self.status = status
    }
}
