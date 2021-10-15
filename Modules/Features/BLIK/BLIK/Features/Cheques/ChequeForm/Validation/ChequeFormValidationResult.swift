//
//  ChequeFormValidationResult.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/07/2021.
//

enum ChequeFormValidationResult {
    case valid(CreateChequeRequest)
    case invalid(InvalidChequeFormMessages)
}
