//
//  PLNotificationListEntity.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLNotificationListEntity {
    public let data: [PLNotificationEntity]
    public let totalElements: Int?
    public let totalPages: Int?
    
    public init(_ dto: PLNotificationListDTO) {
        data = dto.data.map(PLNotificationEntity.init)
        totalElements = dto.totalElements
        totalPages = dto.totalPages
    }
}
