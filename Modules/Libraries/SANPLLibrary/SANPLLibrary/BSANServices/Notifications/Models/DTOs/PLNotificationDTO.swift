//
//  PLNotificationDTO.swift
//  SANPLLibrary
//
//  Created by 188454 on 05/01/2022.
//

public struct PLNotificationDTO: Codable {
    public let id: Int?
    public var status: NotificationStatus
    public let category: EnabledPushCategorie
    public let sendTime: String
    public let title: String
    public let content: String?
    
    public init(id: Int?, status: NotificationStatus, category: EnabledPushCategorie, sendTime: String, title: String, content: String?) {
        self.id = id
        self.status = status
        self.category = category
        self.sendTime = sendTime
        self.title = title
        self.content = content
    }
}
