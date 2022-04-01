import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol SplitPaymentFormPresenterProtocol: RecipientSelectorDelegate, SplitPaymentFormAccountSelectable {

    var view: SplitPaymentFormViewProtocol? { get set }
    func didSelectClose()
    func didSelectCloseProcess()
}

public protocol SplitPaymentFormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class SplitPaymentFormPresenter {
    weak var view: SplitPaymentFormViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var accounts: [AccountForDebit]
    private var selectedAccountNumber: String
    private var confirmationDialogFactory: ConfirmationDialogProducing
    private let mapper: SelectableAccountViewModelMapping
    
    init(
        dependenciesResolver: DependenciesResolver,
        accounts: [AccountForDebit],
        selectedAccountNumber: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        mapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
    }
}

extension SplitPaymentFormPresenter: SplitPaymentFormPresenterProtocol {
    
    func didSelectRecipient(_ recipient: Recipient) {
        // TODO: didSelectRecipient
    }
    
    func updateSelectedAccountNumber(number: String) {
        // TODO: updateSelectedAccountNumber
    }
    
    
    func didSelectClose() {
        coordinator.pop()
    }
    
    func didSelectCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {
            [weak self] in
            self?.coordinator.closeProcess()
        } declineAction: {}
        view?.showDialog(dialog)
    }
}

private extension SplitPaymentFormPresenter {
    var coordinator: SplitPaymentFormCoordinatorProtocol {
        dependenciesResolver.resolve(for: SplitPaymentFormCoordinatorProtocol.self)
    }
}
