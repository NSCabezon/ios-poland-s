//
//  SelectOptionButtonModel.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 25/1/22.
//
import CoreFoundationLib

struct SelectOptionButtonModel: SelectOptionButtonModelRepresentable {
    var titleKey: String
    var action: PublicMenuAction
    var event: String
    var node: KindOfPublicMenuNode
    var accessibilityIdentifier: String?
}
