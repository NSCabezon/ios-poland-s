import Operative
import UI
import CoreFoundationLib
import CoreDomain

final class OperativeContainerCoordinatorDelegateMock: OperativeContainerCoordinatorDelegate {
    func handleOpinator(_ opinator: OpinatorInfoRepresentable) {}
    
    func handleGiveUpOpinator(_ opinator: OpinatorInfoRepresentable, completion: @escaping () -> Void) {
        completion()
    }
    
    func handleWebView(with data: Data, title: String) {}
    
    func executeOffer(_ offer: OfferRepresentable) {}
}
