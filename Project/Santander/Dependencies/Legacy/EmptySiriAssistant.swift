//
//  SiriAssistant.swift
//  Santander
//
//  Created by Victor Carrilero García on 20/01/2021.
//

import Foundation
import RetailLegacy
import Intents

final class EmptySiriAssistant: SiriAssistantProtocol {
    func donate(completion: @escaping (INIntent?) -> Void) {
    }
        
    func getSiriIntentResponseCode(userActivity: NSUserActivity) -> SiriIntentResponseCode? {
        return SiriIntentResponseCode.unspecified
    }
}
