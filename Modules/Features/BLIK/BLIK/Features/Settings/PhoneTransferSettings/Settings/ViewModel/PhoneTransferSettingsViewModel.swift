//
//  PhoneTransferSettingsViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 22/07/2021.
//
import Commons

enum PhoneTransferSettingsViewModel {
    case unregisteredPhoneNumber
    case registeredPhoneNumber
    case expiredPhoneNumber
    
    var title: String {
        return localized("pl_blik_title_payMobile")
    }
    
    var userMessage: String {
        switch self {
        case .unregisteredPhoneNumber, .registeredPhoneNumber:
            return localized("pl_blik_text_payMobileInfo")
        case .expiredPhoneNumber:
            return localized("pl_blik_text_updateNumbInfo")
        }
    }
    
    var icon: UIImage {
        return Images.info_lisboaGray
    }
}
