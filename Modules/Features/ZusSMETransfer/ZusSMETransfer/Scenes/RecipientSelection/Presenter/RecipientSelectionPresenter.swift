import PLCommons
import CoreFoundationLib

protocol RecipientSelectionPresenterProtocol: AnyObject {
    var view: RecipientSelectionViewProtocol? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectCloseProcess()
    func didSelectCell(at row: Int)
}

final class RecipientSelectionPresenter {
    weak var view: RecipientSelectionViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let maskAccount: String?
    private let getRecipientsUseCase: GetRecipientsUseCaseProtocol
    private let coordinator: RecipientSelectionCoordinatorProtocol
    private var recipients: [Recipient]?
    
    init(
        dependenciesResolver: DependenciesResolver,
        maskAccount: String?
    ) {
        coordinator = dependenciesResolver.resolve(for: RecipientSelectionCoordinatorProtocol.self)
        getRecipientsUseCase = dependenciesResolver.resolve(for: GetRecipientsUseCaseProtocol.self)
        self.dependenciesResolver = dependenciesResolver
        self.maskAccount = maskAccount
    }
}

private extension RecipientSelectionPresenter {
    
    func preapareViewModel(with recipients: [Recipient]) {
        var cellViewModelTypes: [RecipientCellViewModelType] = recipients.map {
            return .recipient(
                RecipientCellViewModel(
                    name: $0.name,
                    accountNumber: IBANFormatter.format(
                        iban: IBANFormatter.formatIbanToNrb(for: $0.accountNumber)
                    )
                )
            )
        }
        let isRecipientListEmpty = recipients.isEmpty
        if isRecipientListEmpty {
            cellViewModelTypes.append(
                .empty(
                    EmptyCellViewModel(
                        title: localized("generic_label_empty").text,
                        description: localized("toolbar_zusTransfer_text_noReceipents").text
                    )
                )
            )
        }
        setViewModelInView(
            RecipientSelectionViewModel(
                cellViewModelTypes: cellViewModelTypes,
                isRecipientListEmpty: isRecipientListEmpty
            )
        )
    }
    
    func setViewModelInView(_ viewModel: RecipientSelectionViewModel) {
        view?.setViewModel(viewModel)
    }
}

extension RecipientSelectionPresenter: RecipientSelectionPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoader()
        let input = GetRecipientsUseCaseInput(maskAccount: maskAccount)
        Scenario(useCase: getRecipientsUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    self?.recipients = output.recipients
                    self?.preapareViewModel(with: output.recipients)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: {
                        self?.coordinator.back()
                    })
                })
            }
    }
    
    func didSelectCell(at row: Int) {
        guard let recipient = recipients?[safe: row] else { return }
        coordinator.didSelectRecipient(recipient)
    }
    
    func didSelectBack() {
        coordinator.back()
    }
    
    func didSelectCloseProcess() {
        coordinator.closeProcess()
    }
}
