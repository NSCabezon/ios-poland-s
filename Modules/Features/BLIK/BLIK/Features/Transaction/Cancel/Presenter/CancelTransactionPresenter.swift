import CoreFoundationLib

protocol CancelTransactionPresenterProtocol: MenuTextWrapperProtocol {
    var view: CancelTransactionViewProtocol? { get set }
    var cancelationData: TransactionCancelationData { get }
    func didPressDeleteAlias()
    func didPressBack()
}

final class CancelTransactionPresenter {
    weak var view: CancelTransactionViewProtocol?
    internal let dependenciesResolver: DependenciesResolver
    let cancelationData: TransactionCancelationData

    init(dependenciesResolver: DependenciesResolver, cancelationData: TransactionCancelationData) {
        self.dependenciesResolver = dependenciesResolver
        self.cancelationData = cancelationData
    }
}

extension CancelTransactionPresenter: CancelTransactionPresenterProtocol {
    func didPressDeleteAlias() {
        view?.showLoader()
        Scenario(useCase: getAliasesUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] aliases in
                self?.view?.hideLoader(completion: {
                    self?.handleFetchedAliases(aliases)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: nil)
                })
            }
    }
    
    func didPressBack() {
        coordinator.goToGlobalPosition()
    }
    
    private func handleFetchedAliases(_ aliases: [BlikAlias]) {
        let potentialAliasUsedInTransaction: Transaction.Alias? = {
            switch cancelationData.aliasContext {
            case let .transactionPerformedWithAlias(alias):
                return alias
            case .transactionPerformedWithoutAlias:
                return nil
            }
        }()
        guard let aliasUsedInTransaction = potentialAliasUsedInTransaction else {
            view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: nil)
            return
        }
        
        let matchedBlikAliases = aliases.filter { $0.label == aliasUsedInTransaction.label }
        
        let areThereMultipleAliasesWithSameLabel = (matchedBlikAliases.count > 1)
        if areThereMultipleAliasesWithSameLabel {
            coordinator.showAliasesList()
            return
        }
        
        let isThereOnlyOneMatchedAlias = (matchedBlikAliases.count == 1)
        if let matchedAlias = matchedBlikAliases.first, isThereOnlyOneMatchedAlias {
            coordinator.showAliasDeletion(of: matchedAlias)
            return
        }
        
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: nil)
    }
}

private extension CancelTransactionPresenter {
    var coordinator: CancelTransactionCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var getAliasesUseCase: GetAliasesUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
}
