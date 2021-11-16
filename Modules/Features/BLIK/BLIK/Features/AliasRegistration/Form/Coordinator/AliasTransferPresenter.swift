import Commons
import PLCommons
import Commons
import PLUI
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary

protocol AliasTransferPresenterProtocol {
    func viewDidLoad()
    func didPressSave()
    func didPressReject()
    func didPressClose()
}

final class AliasTransferPresenter: AliasTransferPresenterProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    private var aliasType: AliasType
    private let registerAliasInput: RegisterBlikAliasInput

    
    private var coordinator: AliasTransferCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    private var registerUseCase: AliasTransactionRegisterAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var registerAliasUseCase: AliasTransactionRegisterAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    weak var view: AliasTransferViewController?
    
    init(
        registerAliasInput: RegisterBlikAliasInput,
        aliasType: AliasType,
        dependenciesResolver: DependenciesResolver
    ) {
        self.registerAliasInput = registerAliasInput
        self.aliasType = aliasType
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        let aliasMessage: String = {
            switch self.aliasType {
            case .cookie:
                return "#Aplikacja zapamięta przeglądarkę, z której dokonałeś zakupu. Będziesz mógł robić zakupy bez podawania kodu BLIK we wszystkich sklepach internetowych na zapamiętanej przeglądarce."
            case .uid:
                return "#Aplikacja zapamięta sklep, w którym kupowałeś. Jeśli będziesz zalogowany do sklepu, to zrobisz zakupy bez podawania kodu BLIK na każdym urządzeniu i przeglądarce."
            }
        }()
        let viewModel = AliasTransferContentViewModel(text: aliasMessage)
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
