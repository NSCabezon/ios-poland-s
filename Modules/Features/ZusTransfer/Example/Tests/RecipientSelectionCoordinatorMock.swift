@testable import ZusTransfer

final class RecipientSelectionViewCoordinatorMock: RecipientSelectionCoordinatorProtocol {
    var backCalled = false
    var closeProcessCalled = false
    var didSelectRecipientCalled = false
        
    func back() {
        backCalled = true
    }
    
    func didSelectRecipient(_ recipient: Recipient) {
        didSelectRecipientCalled = true
    }
    
    func closeProcess() {
        closeProcessCalled = true
    }
}
