//
//  AliasListSettingsViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 01/09/2021.
//

enum AliasListSettingsViewModel {
    typealias HeaderMessage = String
    struct AliasElementViewModel {
        let aliasName: String
        let associatedModel: BlikAlias
    }
    
    case header(HeaderMessage)
    case alias(AliasElementViewModel)
    case emptyDataMessage(EmptyDataMessageViewModel)
}
