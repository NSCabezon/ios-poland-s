//
//  ESDeeplink.swift
//  Santander
//
//  Created by Francisco del Real Escudero on 13/4/21.
//

import Models

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
}

extension PolandDeepLink: DeepLinkEnumerationCapable {
    init?(_ string: String, userInfo: [DeepLinkUserInfoKeys: String] = [:]) {
        switch string {
        case PolandDeepLink.helpCenter.deepLinkKey: self = .helpCenter
        case PolandDeepLink.contact.deepLinkKey: self = .contact
        case PolandDeepLink.blikTransaction.deepLinkKey: self = .blikTransaction
        default: return nil
        }
    }
    
    public var trackerId: String? {
        switch self {
        case .helpCenter: return "helpCenter_pl"
        case .contact: return "contact_pl"
        case .blikTransaction: return "blikTransaction_pl"
        }
    }
    
    var deepLinkKey: String {
        switch self {
        case .helpCenter: return "helpCenter"
        case .contact: return "contact"
        case .blikTransaction: return "blikTransaction"
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
        }
    }
}
