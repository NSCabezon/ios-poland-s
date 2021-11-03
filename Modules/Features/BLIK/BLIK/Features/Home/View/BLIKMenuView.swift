//
//  BLIKMenuList.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import UIKit
import Commons

typealias BLIKMenuView = MenuView<BLIKMenuViewModel>

struct BLIKMenuViewModel: MenuViewModel {
    let item: BLIKMenuItem
    
    var image: UIImage {
        switch item {
        case .mobileTransfer:
            return Images.Menu.mobileTransfer
        case .cheque:
            return Images.Menu.cheque
        case .aliasPayment:
            return Images.Menu.alias
        case .settings:
            return Images.Menu.settings
        }
    }
    
    var title: String {
        switch item {
        case .mobileTransfer:
            return localized("pl_blik_text_payMobile")
        case .cheque:
            return localized("pl_blik_text_cheque")
        case .aliasPayment:
            return localized("pl_blik_text_withoutCode")
        case .settings:
            return localized("pl_blik_text_blikSettings")
        }
    }
    
    var description: String {
        switch item {
        case .mobileTransfer:
            return localized("pl_blik_label_payMobileDesc")
        case .cheque:
            return localized("pl_blik_label_chequeDesc")
        case .aliasPayment:
            return localized("pl_blik_label_withoutCodeDesc")
        case .settings:
            return localized("pl_blik_label_blikSettingsDesc")
        }
    }
}
