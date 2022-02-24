//
//  PLNotificationEntity.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

import CoreFoundationLib

public struct PLNotificationEntity: DTOInstantiable {
    public let dto: PLNotificationDTO
    public var status: NotificationStatus
    
    public init(_ dto: PLNotificationDTO) {
        self.dto = dto
        self.status = dto.status
    }
    
    public var id: Int? {
        return dto.id
    }
    
    public var category: EnabledPushCategorie {
        return dto.category
    }
    
    public var sendTime: String {
        return dto.sendTime
    }
    
    public var title: String {
        return dto.title
    }
    
    public var content: String? {
        return dto.content
    }
}
