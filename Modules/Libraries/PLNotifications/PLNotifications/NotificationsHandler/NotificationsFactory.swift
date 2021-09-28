//
//  NotificationsFactory.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import Foundation

final class NotificationsFactory {

    static func createNotification(_ systemNotification: SystemNotification, date: Date) -> PLNotification {
        return PLNotification(date: date, systemNotification: systemNotification)
    }
}
