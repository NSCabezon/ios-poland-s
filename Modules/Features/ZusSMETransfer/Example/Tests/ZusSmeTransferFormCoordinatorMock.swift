import PLCommons
@testable import ZusSMETransfer

final class ZusSmeTransferFormCoordinatorMock: ZusSmeTransferFormCoordinatorProtocol {
    var showConfirmationCalled = false
    var showAccountSelectorCalled = false
    var closeProcessCalled = false
    var popCalled = false
    var showRecipientSelectionCalled = false
    var updateAccountsCalled = false

    func pop() {
        popCalled = true
    }
    
    func closeProcess() {
        closeProcessCalled = true
    }
    
    func showAccountSelector(selectedAccountNumber: String) {
        showAccountSelectorCalled = true
    }
    
    func showConfiramtion(model: ZusSmeTransferModel) {
        showConfirmationCalled = true
    }
    
    func showRecipientSelection(with maskAccount: String?) {
        showRecipientSelectionCalled = true
    }

    func updateAccounts(accounts: [AccountForDebit]) {
        updateAccountsCalled = true
    }
}

