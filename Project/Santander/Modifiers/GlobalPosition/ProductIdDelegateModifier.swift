//
//  ProductIdDelegateModifier.swift
//  Santander
//

import GlobalPosition
import CoreFoundationLib

final class ProductIdDelegateModifier: ProductIdDelegateProtocol {
    func showMaskedLoanId(_ loan: LoanEntity) -> String {
        return loan.shortContract
    }
}
