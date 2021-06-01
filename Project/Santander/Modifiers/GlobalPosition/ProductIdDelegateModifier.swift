//
//  ProductIdDelegateModifier.swift
//  Santander
//

import GlobalPosition
import Models

final class ProductIdDelegateModifier: ProductIdDelegateProtocol {
    func showMaskedLoanId(_ loan: LoanEntity) -> String {
        return loan.shortContract
    }
}
