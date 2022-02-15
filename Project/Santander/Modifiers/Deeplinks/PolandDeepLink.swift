//
//  ESDeeplink.swift
//  Santander
//
//  Created by Francisco del Real Escudero on 13/4/21.
//

import CoreFoundationLib

/** NOTE: It is possible to create deep link with arguments eg.
 case helpCenterWithInfo(info: String)
 And it works when its created like that:
 let deepLinkManager = dependenciesEngine.resolve(for: DeepLinkManagerProtocol.self)
 deepLinkManager.registerDeepLink(PolandDeepLink.helpCenterWithInfo(info: "SomeInfo"))
 But there is problem with implementing DeepLinkEnumerationCapable protocol
 Especially with the init method.
 */
enum PolandDeepLink: CaseIterable {
    case helpCenter
    case contact
    case blikTransaction
    case ourOffer
    case alertsNotification
    case sendMoney
    case services
    case blik
}

extension PolandDeepLink: DeepLinkEnumerationCapable {
    init?(_ string: String, userInfo: [DeepLinkUserInfoKeys: String] = [:]) {
        switch string {
        case PolandDeepLink.helpCenter.deepLinkKey: self = .helpCenter
        case PolandDeepLink.contact.deepLinkKey: self = .contact
        case PolandDeepLink.blikTransaction.deepLinkKey: self = .blikTransaction
        case PolandDeepLink.ourOffer.deepLinkKey: self = .ourOffer
        case PolandDeepLink.alertsNotification.deepLinkKey: self = .alertsNotification
        case PolandDeepLink.sendMoney.deepLinkKey: self = .sendMoney
        case PolandDeepLink.services.deepLinkKey: self = .services
        case PolandDeepLink.blik.deepLinkKey: self = .blik
        default: return nil
        }
    }
    
    public var trackerId: String? {
        switch self {
        case .helpCenter: return "helpCenter_pl"
        case .contact: return "contact_pl"
        case .blikTransaction: return "blikTransaction_pl"
        case .ourOffer: return "ourOffer_pl"
        case .alertsNotification: return "alertsNotification_pl"
        case .sendMoney: return "sendMoney_pl"
        case .services: return "services_pl"
        case .blik: return "blik_pl"
        }
    }
      
    var deepLinkKey: String {
        switch self {
        case .helpCenter: return "helpCenter"
        case .contact: return "contact"
        case .blikTransaction: return "blikTransaction"
        case .ourOffer: return "new_bbc_offer"
        case .alertsNotification: return "alerts_notification"
        case .sendMoney: return "send_money"
        case .services: return "services"
        case .blik: return "blik"
        }
    }
    
    /** NOTE: privateDeepLink in opened on GlobalPosition after login
        other DeepLinks can be opened before login, but it seems that there is a bug and the change environment button must be tapped first
     */
    var accessType: DeepLinkAccessType {
        switch self {
        case .helpCenter: return .privateDeepLink
        case .contact: return .publicDeepLink
        case .blikTransaction: return .privateDeepLink // TODO:- Change deepLink to public later (MVP expects it to be private)
        case .ourOffer: return .privateDeepLink
        case .alertsNotification: return .privateDeepLink
        case .sendMoney: return .privateDeepLink
        case .services: return .privateDeepLink
        case .blik: return .privateDeepLink
        }
    }
}
