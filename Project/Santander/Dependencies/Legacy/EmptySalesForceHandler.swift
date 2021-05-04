//
//  EmptySalesForceHandler.swift
//  Santander
//
//  Created by Jose C. Yebes on 4/05/2021.
//

import Foundation
import RetailLegacy
import Models

class EmptySalesForceHandler: SalesForceHandlerProtocol {
    func setConfiguration(timeManager: TimeManager, stringLoader: StringLoader) {
        
    }
    
    func setContactKey(_ contactKey: String) {
        
    }
    
    func register(_ deviceToken: Data) {
        
    }
    
    func setNotificationRequest(_ request: UNNotificationRequest) {
        
    }
    
    func getUserInbox(completion: @escaping ([PushNotification]?) -> Void) {
        
    }
    
    func markAsRead(notification: PushNotification) {
        
    }
    
    func markAllAsRead() {
        
    }
    
    func delete(notification: PushNotification) {
        
    }
    
    func deleteAll() {
        
    }
    
    func markAsRead(notification: PushNotificationEntity) {
        
    }
    
    func getUserInboxBridge(completion: @escaping ([PushNotificationEntity]?) -> Void) {
        
    }
    
    func delete(notification: PushNotificationEntity) {
        
    }
}
