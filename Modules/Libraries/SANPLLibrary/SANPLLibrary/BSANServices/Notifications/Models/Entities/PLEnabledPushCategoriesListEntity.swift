//
//  PLEnabledPushCategoriesListEntity.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 15/02/2022.
//

public struct PLEnabledPushCategoriesListEntity {
    public let enabledCategories: [EnabledPushCategorie]
    
    public init(_ dto: PLEnabledPushCategoriesDTO) {
        enabledCategories = dto.enabledCategories
    }
}
