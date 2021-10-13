//
//  NotificationRegisterParameters.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 24/9/21.
//

import Foundation

public struct NotificationRegisterParameters: Encodable {
    let notificationToken: String

    public init(notificationToken: String) {
        self.notificationToken = notificationToken
    }
}
