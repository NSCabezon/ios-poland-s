import Foundation
import Operative
import PLCommons
import PLCommonOperatives
import CoreFoundationLib

protocol ZusSmeTransferDataLoaderPresenterProtocol: AnyObject {
    var view: ZusSmeTransferDataLoaderViewProtocol? { get set }
    func viewDidLoad()
    func close()
}

final class ZusSmeTransferDataLoaderPresenter {
    weak var view: ZusSmeTransferDataLoaderViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: ZusSmeTransferDataLoaderCoordinatorProtocol?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(
            for: ZusSmeTransferDataLoaderCoordinatorProtocol.self
        )
    }
}

extension ZusSmeTransferDataLoaderPresenter: ZusSmeTransferDataLoaderPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(
            useCase: GetAccountsForDebitUseCase(
                transactionType: .zusTransfer,
                dependenciesResolver: dependenciesResolver
            )
        )
        .execute(on: dependenciesResolver.resolve())
        .onSuccess { [weak self] accounts in
            guard let self = self else { return }
            self.view?.hideLoader(completion: {
                if accounts.isEmpty {
                    self.view?.showEmptyAccountsDialog(
                        title: localized("pl_popup_noSourceAccTitle"),
                        description: localized("pl_popup_noSourceAccParagraph")
                    )
                    return
                }
                if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
                    let selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? accounts.first?.number ?? ""
                    self.coordinator?.showZusTransferForm(with: accounts, selectedAccountNumber: selectedAccountNumber)
                } else {
                    self.coordinator?.showZusAccountSelector(with: accounts)
                }
            })
        }
        .onError { [weak self] _ in
            self?.view?.hideLoader(completion: {
                self?.showErrorView()
            })
        }
    }
    
    func close() {
        coordinator?.close()
    }
}

private extension ZusSmeTransferDataLoaderPresenter {
    func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator?.close()
        })
    }
}
