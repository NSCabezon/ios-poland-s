//
//  PublicMenuOption.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 25/1/22.
//
import CoreFoundationLib

struct PublicMenuOption: PublicMenuOptionRepresentable {
    var kindOfNode: KindOfPublicMenuNode
    var titleKey: String
    var iconKey: String
    var action: PublicMenuAction
    var accessibilityIdentifier: String?
    var type: PublicMenuOptionType
    
    init(kindOfNode: KindOfPublicMenuNode,
         titleKey: String,
         iconKey: String,
         action: PublicMenuAction,
         accessibilityIdentifier: String?,
         type: PublicMenuOptionType) {
        self.kindOfNode = kindOfNode
        self.titleKey = titleKey
        self.iconKey = iconKey
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.type = type
    }
}
