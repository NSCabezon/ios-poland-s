//
//  PLInternalTransferAmountModifier.swift
//  TransferOperatives
//
//  Created by Marcos Álvarez Mesa on 26/2/22.
//

import TransferOperatives
import CoreFoundationLib

public class PLInternalTransferAmountModifier: InternalTransferAmountModifierProtocol {

    public var isDescriptionRequired: Bool {
        return true
    }

    public var shoulFocusDescription: Bool {
        return true
    }

    public var descriptionRegularExpression: NSRegularExpression? {
        let regexCons = "[a-zA-Z0-9ąć ęłńóśźżĄĆĘŁŃÓŚŹŻ`!@#$%^&*()_+-=\\[\\]{};:,.?/–\\\\]+$"
        return try? NSRegularExpression(pattern: regexCons)
    }
    
    public var inputDescriptionKey: String? {
        return "transfer_label_transferOwnAccount"
    }
    
    public func getSelectionDateOneFilterData(_ index: Int) -> SelectionDateOneFilterData? {
        let labelData = OneLabelViewModel(type: .normal,
                                               mainTextKey: "transfer_label_periodicity",
                                               accessibilitySuffix: AccessibilitySendMoneyAmount.periodicitySuffix)
        let data = SelectionDateOneFilterData(oneLabelData: labelData,
                                                        options: ["sendMoney_tab_today", "sendMoney_tab_chooseDay"],
                                                        selectedIndex: index)
        return data
    }
}
