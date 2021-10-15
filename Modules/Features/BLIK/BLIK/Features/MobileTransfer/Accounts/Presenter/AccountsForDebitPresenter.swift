import Models
import Commons
import PLUI

final class AccountsForDebitPresenter {

    weak var view: AccountSelectorViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var viewModels: [SelectableAccountViewModel] = []
    private let sourceView: SourceView
    weak var selectableDelegate: FormAccountSelectable?
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()

    init(dependenciesResolver: DependenciesResolver,
         viewModels: [SelectableAccountViewModel],
         sourceView: SourceView,
         selectableDelegate: FormAccountSelectable?) {
        self.dependenciesResolver = dependenciesResolver
        self.viewModels = viewModels
        self.sourceView = sourceView
        self.selectableDelegate = selectableDelegate
    }
}

private extension AccountsForDebitPresenter {
    var coordinator: AccountsForDebitCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: AccountsForDebitCoordinatorProtocol.self)
    }
}

extension AccountsForDebitPresenter: AccountSelectorPresenterProtocol {
    func didSelectAccount(at index: Int) {
        let previouslySelectedAccount = viewModels.firstIndex(where: { $0.isSelected }) ?? 0
        viewModels[previouslySelectedAccount].isSelected = false
        viewModels[index].isSelected = true
        
        switch sourceView {
        case .contacts:
            coordinator.showTransferForm(accounts: viewModels)
        case .form:
            selectableDelegate?.updateViewModel(with: viewModels)
            didPressClose()
        }
        
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func viewDidLoad() {
        view?.setViewModels(viewModels)
    }
    
    func didCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.closeProcess()
        }
        declineAction: {}
        
        view?.showDialog(dialog)
    }
}
