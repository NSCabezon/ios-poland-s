import Foundation
import Operative
import PLCommons
import PLCommonOperatives
import CoreFoundationLib

protocol CharityTransferModulePresenterProtocol: AnyObject {
    var view: CharityTransferModuleViewProtocol? { get set }
    func viewDidLoad()
}

final class CharityTransferModulePresenter {
    weak var view: CharityTransferModuleViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: CharityTransferModuleCoordinatorProtocol?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(
            for: CharityTransferModuleCoordinatorProtocol.self
        )
    }
}

extension CharityTransferModulePresenter: CharityTransferModulePresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(
            useCase: GetAccountsForDebitUseCase(
                transactionType: .charityTransfer,
                dependenciesResolver: dependenciesResolver
            )
        )
        .execute(on: dependenciesResolver.resolve())
        .onSuccess { [weak self] accounts in
            guard let self = self else { return }
            self.view?.hideLoader(completion: {
                if accounts.isEmpty {
                    self.showErrorView()
                    return
                }
                if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
                    let selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? accounts.first?.number ?? ""
                    self.coordinator?.showCharityTransferForm(with: accounts, selectedAccountNumber: selectedAccountNumber)
                } else {
                    self.coordinator?.showCharityAccountSelector(with: accounts)
                }
            })
        }
        .onError { [weak self] _ in
            self?.view?.hideLoader(completion: {
                self?.showErrorView()
            })
        }
    }
    
    private func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator?.close()
        })
    }
}
