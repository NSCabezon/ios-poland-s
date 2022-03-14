//
//  PLUnreadedPushCountEntity.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLUnreadedPushCountEntity {
    public let count: Int
    
    public init(_ dto: PLUnreadedPushCountDTO) {
        count = dto.count
    }
}
