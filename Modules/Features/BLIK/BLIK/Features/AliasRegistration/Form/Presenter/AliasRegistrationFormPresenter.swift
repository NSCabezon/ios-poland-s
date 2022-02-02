import CoreFoundationLib
import PLCommons
import PLUI
import SANPLLibrary
import SANLegacyLibrary

protocol AliasRegistrationFormPresenterProtocol {
    func viewDidLoad()
    func didPressSave()
    func didPressReject()
    func didPressClose()
    func goToGlobalPosition()
}

final class AliasRegistrationFormPresenter: AliasRegistrationFormPresenterProtocol {
    private let registerAliasInput: RegisterAliasInput
    private let dependenciesResolver: DependenciesResolver
    weak var view: AliasRegistrationFormViewController?
    
    init(
        registerAliasInput: RegisterAliasInput,
        dependenciesResolver: DependenciesResolver
    ) {
        self.registerAliasInput = registerAliasInput
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        let aliasMessage: String = {
            switch self.registerAliasInput.aliasProposal.type {
            case .cookie:
                return localized("pl_blik_text_saveBrowser")
            case .uid:
                return localized("pl_blik_text_saveShop")
            }
        }()
        let viewModel = AliasRegistrationFormContentViewModel(text: aliasMessage)
        view?.set(viewModel: viewModel)
    }
    
    func didPressSave() {
        Scenario(useCase: registerAliasUseCase, input: registerAliasInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.view?.hideLoader(completion: {
                    self?.coordinator.goToAliasRegistrationSummary()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressReject() {
        coordinator.close()
    }

    func didPressClose() {
        coordinator.close()
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
}

private extension AliasRegistrationFormPresenter {
    var coordinator: AliasRegistrationFormCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var registerAliasUseCase: RegisterAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
}
