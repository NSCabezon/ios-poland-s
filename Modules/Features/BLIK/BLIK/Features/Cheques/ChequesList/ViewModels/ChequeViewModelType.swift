//
//  ChequeViewModelType.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 15/06/2021.
//

enum ChequeViewModelType {
    case cheques([ChequeViewModel])
    case emptyDataMessage(EmptyDataMessageViewModel)
    case error(ErrorCellViewModel)
}
