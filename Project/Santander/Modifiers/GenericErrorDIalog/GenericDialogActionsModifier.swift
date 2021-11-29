//
//  GenericDialogActionsModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 29/11/21.
//

import Foundation
import UI

final class GenericDialogActionsModifier { }

extension GenericDialogActionsModifier: GenericDialogAddBranchLocatorActionCapable {
    func isBranchLocatorActionAvailable() -> Bool {
        return false
    }

    func branchLocatorAction() {
        // N/A
    }
}
