//
//  Element+extensions.swift
//  PLHelpCenter
//
//  Created by 187452 on 23/08/2021.
//

import CoreFoundationLib
import PLUI
import UI

extension HelpCenterConfig.Element {
    
    enum Icon {
        case local(image: UIImage?)
        case remote(url: String)
        case none
    }
    
    var title: String {
        switch self {
        case .blockCard: return localized("pl_helpdesk_button_blockCard")
        case .yourCases: return localized("pl_helpdesk_button_yourItemsOnline")
        case .mailContact: return localized("pl_helpdesk_button_mailTextUs")
        case .call: return localized("pl_helpdesk_button_callHelpLine")
        case .advisor(let name, _, _): return name
        case .expandableHint(let question, _): return question
        case .info(let message): return message
        case .subject(let details): return details.name
        }
    }
    
    var icon: Icon {
        switch self {
        case .blockCard: return .local(image: UIImage(named: "blockCardSymbol", in: .module, compatibleWith: nil))
        case .yourCases: return .local(image: UIImage(named: "laptopSymbol", in: .module, compatibleWith: nil))
        case .mailContact: return .local(image: UIImage(named: "letterSymbol", in: .module, compatibleWith: nil))
        case .call: return .local(image: UIImage(named: "phoneSymbol", in: .module, compatibleWith: nil))
        case .info: return .local(image: UIImage(named: "infoSymbol", in: .module, compatibleWith: nil))
        case .advisor(_,let iconUrl, _): return .remote(url: iconUrl)
        case .subject(let details): return .remote(url: details.iconUrl)
        case .expandableHint: return .none
        }
    }

    var isAccesoryImageViewHidden: Bool {
        if case .call = self {
            return false
        } else {
            return true
        }
    }
    
    var webViewIdentifier: String? {
        switch self {
        case .yourCases:
            return "CUSTOMER_SERVICE" // TODO: Maybe move PLAccountOtherOperativesIdentifier to PLCommon and use it here?
        case .mailContact:
            return "MAILBOX"
        default: // TODO: Add rest of the cases in separate tasks
            return nil
        }
    }
}
