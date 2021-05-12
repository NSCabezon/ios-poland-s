//
//  PLManagerNotificationsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLManagerNotificationsManagerAdapter {}
 
extension PLManagerNotificationsManagerAdapter: BSANManagerNotificationsManager {
    func getManagerNotificationsInfo() throws -> BSANResponse<ManagerNotificationsDTO> {
        let notifications = ManagerNotificationsDTO(unreadMessages: "0")
        return BSANOkResponse(notifications)
    }
}
