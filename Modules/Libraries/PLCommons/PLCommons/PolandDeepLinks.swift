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
public enum PolandDeepLink: CaseIterable {
    
    case helpCenter
    case contact
    case blikTransaction
    case ourOffer
    case alertsNotification
    case sendMoney
    case services
    case blik
    case myProducts(entryType: String, mediumType: String, subjectID: String, baseAddress: String)
    case onlineAdvisor(params: String)
    
    public static var allCases: [PolandDeepLink] {
        return [.helpCenter,
                .contact,
                .blikTransaction,
                .ourOffer,
                .alertsNotification,
                .sendMoney,
                .services,
                .blik,
                .onlineAdvisor(params: ""),
                .myProducts(entryType: "", mediumType: "", subjectID: "", baseAddress: "")]
    }
}

extension PolandDeepLink: DeepLinkEnumerationCapable {
    public init?(_ string: String, userInfo: [DeepLinkUserInfoKeys: String] = [:]) {
        switch string {
        case PolandDeepLink.helpCenter.deepLinkKey: self = .helpCenter
        case PolandDeepLink.contact.deepLinkKey: self = .contact
        case PolandDeepLink.blikTransaction.deepLinkKey: self = .blikTransaction
        case PolandDeepLink.ourOffer.deepLinkKey: self = .ourOffer
        case PolandDeepLink.alertsNotification.deepLinkKey: self = .alertsNotification
        case PolandDeepLink.sendMoney.deepLinkKey: self = .sendMoney
        case PolandDeepLink.services.deepLinkKey: self = .services
        case PolandDeepLink.blik.deepLinkKey: self = .blik
        case PolandDeepLink.myProducts(entryType: "", mediumType: "", subjectID: "", baseAddress: "").deepLinkKey: self = .myProducts(
            entryType: userInfo[CoreFoundationLib.DeepLinkUserInfoKeys.identifier] ?? "",
            mediumType: userInfo[CoreFoundationLib.DeepLinkUserInfoKeys.date] ?? "",
            subjectID: userInfo[CoreFoundationLib.DeepLinkUserInfoKeys.authorizationId] ?? "",
            baseAddress: userInfo[CoreFoundationLib.DeepLinkUserInfoKeys.scope] ?? ""
        )
        case PolandDeepLink.onlineAdvisor(params: "").deepLinkKey:
            self = .onlineAdvisor(params: userInfo[CoreFoundationLib.DeepLinkUserInfoKeys.date] ?? "")
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
        case .myProducts: return "myProducts"
        case .onlineAdvisor: return "onlineAdvisor"
        }
    }
      
    public var deepLinkKey: String {
        switch self {
        case .helpCenter: return "helpCenter"
        case .contact: return "contact"
        case .blikTransaction: return "blikTransaction"
        case .ourOffer: return "new_bbc_offer"
        case .alertsNotification: return "alerts_notification"
        case .sendMoney: return "send_money"
        case .services: return "services"
        case .blik: return "blik"
        case .myProducts: return "myProducts"
        case .onlineAdvisor: return "onlineAdvisor"
        }
    }
    
    /** NOTE: privateDeepLink in opened on GlobalPosition after login
        other DeepLinks can be opened before login, but it seems that there is a bug and the change environment button must be tapped first
     */
    public var accessType: DeepLinkAccessType {
        switch self {
        case .helpCenter: return .privateDeepLink
        case .contact: return .publicDeepLink
        case .blikTransaction: return .privateDeepLink // TODO:- Change deepLink to public later (MVP expects it to be private)
        case .ourOffer: return .privateDeepLink
        case .alertsNotification: return .privateDeepLink
        case .sendMoney: return .privateDeepLink
        case .services: return .privateDeepLink
        case .blik: return .privateDeepLink
        case .myProducts: return .privateDeepLink
        case .onlineAdvisor: return  .publicDeepLink
        }
    }
}

