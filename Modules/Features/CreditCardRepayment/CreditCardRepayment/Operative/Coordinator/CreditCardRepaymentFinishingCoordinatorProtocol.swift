import Foundation
import Operative
import SANLegacyLibrary
import SANPLLibrary

protocol CreditCardRepaymentFinishingCoordinatorProtocol: OperativeFinishingCoordinator {
    func goToGlobalPosition()
    func goToMakeAnotherPayment(_ coordinator: OperativeContainerCoordinatorProtocol)
}

extension CreditCardRepaymentFinishingCoordinatorProtocol {
    func didFinishSuccessfully(_ coordinator: OperativeContainerCoordinatorProtocol, operative: Operative) {
        if let dataProvider = operative.dependencies.resolve(for: BSANDataProviderProtocol.self) as? SANPLLibrary.BSANDataProvider {
            dataProvider.cleanCreditCardRepaymentInfo()
        }
        guard let finishingOption = self.getFinishingOption(for: operative) else {
            self.gotoCoordinatorSourceController(coordinator)
            return
        }
        switch finishingOption {
        case .globalPosition:
            self.goToGlobalPosition()
        case .makeAnotherPayment:
            self.goToMakeAnotherPayment(coordinator)
        }
    }
}

private extension CreditCardRepaymentFinishingCoordinatorProtocol {
    func getFinishingOption(for operative: Operative) -> CreditCardRepaymentOperative.FinishingOption? {
        guard let operative = operative as? CreditCardRepaymentOperative else { return nil }
        guard let finishingOption: CreditCardRepaymentOperative.FinishingOption = operative.container?.getOptional() else { return nil }
        return finishingOption
    }
    
    func gotoCoordinatorSourceController(_ coordinator: OperativeContainerCoordinatorProtocol) {
        guard let controller = coordinator.sourceView else {
            coordinator.navigationController?.popToRootViewController(animated: true)
            return
        }
        coordinator.navigationController?.popToViewController(controller, animated: true)
    }
}
