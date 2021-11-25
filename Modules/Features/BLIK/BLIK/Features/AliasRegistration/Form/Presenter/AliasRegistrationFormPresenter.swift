import Commons
import PLCommons
import Commons
import PLUI
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

protocol AliasRegistrationFormPresenterProtocol {
    func viewDidLoad()
    func didPressSave()
    func didPressReject()
    func didPressClose()
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
                return "#Aplikacja zapamięta przeglądarkę, z której dokonałeś zakupu. Będziesz mógł robić zakupy bez podawania kodu BLIK we wszystkich sklepach internetowych na zapamiętanej przeglądarce."
            case .uid:
                return "#Aplikacja zapamięta sklep, w którym kupowałeś. Jeśli będziesz zalogowany do sklepu, to zrobisz zakupy bez podawania kodu BLIK na każdym urządzeniu i przeglądarce."
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
                    self?.coordinator.close()
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
