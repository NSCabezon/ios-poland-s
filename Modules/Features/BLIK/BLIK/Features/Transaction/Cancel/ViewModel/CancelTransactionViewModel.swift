//
//  CancelTransactionViewModel.swift
//  Account
//
//  Created by 185167 on 02/03/2022.
//

struct CancelTransactionViewModel {
    let infoLabelLocalizationKey: String
    let bottomButtonsArrangement: BottomButtonsArrangement
    
    enum BottomButtonsArrangement {
        typealias DeleteAliasText = String
        
        case onlyBackButton
        case backAndDeleteAliasButtons(DeleteAliasText)
    }
}
