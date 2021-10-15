//
//  ErrorCellViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 23/06/2021.
//

struct ErrorCellViewModel {
    let title: String
    let subtitle: String
    let refreshButtonState: RefreshButtonState
    
    typealias RefreshButtonAction = () -> Void
    enum RefreshButtonState {
        case hidden
        case present(RefreshButtonAction)
    }
}
