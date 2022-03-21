//
//  ProductActionsShortcutsMatrix.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 31/1/22.
//

import Foundation
import SANPLLibrary

public enum ProductActionsShortcutsType: String {
    case cards
    case accounts
    case loans
    case savings
}

public enum ProductActionsShortcutsState: String {
    case enabled
    case disabled
    case hidden
}

public struct ProductActionsShortcutsMatrix {
    
    private let operations: [OperationsProductsDTO]?
    
    init(operations: [OperationsProductsDTO]?) {
        self.operations = operations
    }
        
    public func getEnabledOperationsIdentifiers(type: ProductActionsShortcutsType, contract: String) -> [String]? {

        guard let operations = self.getOperationsProducts(type: type, contract: contract) else { return nil }
        
        let enabledOperations = operations.filter { operation in
            return operation.state == ProductActionsShortcutsState.enabled.rawValue
        }

        return enabledOperations.compactMap { operation in operation.id }
    }

    public func getOperationsProducts(type: ProductActionsShortcutsType, contract: String) -> [OperationsProductsStatesDTO]? {

        guard let types = operations?.first(where: { operation in operation.type == type.rawValue }),
              let contract = types.contracts?.first(where: { product in product.id == contract }) else {
            return nil
        }

        return contract.operations
    }
}
