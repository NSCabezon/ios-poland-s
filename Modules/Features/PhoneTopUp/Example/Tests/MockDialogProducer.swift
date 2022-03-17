//
//  MockDialogProducer.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 14/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLUI
import UI

final class MockDialogProducer: ConfirmationDialogProducing {
    
    var createDialogCallCount = 0
    
    func create(message: String, confirmAction: @escaping () -> Void, declineAction: @escaping () -> Void) -> LisboaDialog {
        defer {
            confirmAction()
        }
        return createMockLisboaDialog()
    }
    
    func createEndProcessDialog(confirmAction: @escaping () -> Void, declineAction: @escaping () -> Void) -> LisboaDialog {
        defer {
            confirmAction()
        }
        return createMockLisboaDialog()
    }
    
    func createLimitIncreasingDialog(confirmAction: @escaping () -> Void, declineAction: @escaping () -> Void) -> LisboaDialog {
        defer {
            confirmAction()
        }
        return createMockLisboaDialog()
    }
    
    private func createMockLisboaDialog() -> LisboaDialog {
        createDialogCallCount += 1
        return LisboaDialog(items: [], closeButtonAvailable: true, executeCancelActionOnClose: true)
    }
}
