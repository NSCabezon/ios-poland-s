//
//  PLNotificationListDTO.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLNotificationListDTO: Codable {
    public let data: [PLNotificationDTO]
    public let totalElements: Int?
    public let totalPages: Int?
}
