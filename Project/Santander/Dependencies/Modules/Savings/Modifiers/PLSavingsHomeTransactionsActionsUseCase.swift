//
//  PLSavingsHomeModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 18/4/22.
//

import Foundation
import SavingProducts
import CoreFoundationLib
import OpenCombine
import UI
import CoreDomain

public struct PLSavingsHomeTransactionsActionsUseCase: SavingsHomeTransactionsActionsUseCase {
    public func getAvailableTransactionsButtonActions(for savingProduct: SavingProductRepresentable) -> AnyPublisher<[SavingProductsTransactionsButtonsType], Never> {
        return Just([.downloadPDF]).eraseToAnyPublisher()
    }
}
