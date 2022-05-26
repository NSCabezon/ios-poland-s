import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLUI

protocol PLQuickBalancePresenterProtocol: AnyObject {
    var view: PLQuickBalanceViewProtocol? { get set }
    func viewDidLoad()
    func pop()
    func showEnableQuickBalanceView()
    func handleServiceInaccessible()
}

final class PLQuickBalancePresenter {
    let dependenciesResolver: DependenciesResolver

    weak var view: PLQuickBalanceViewProtocol?
    
    var coordinator: PLQuickBalanceCoordinatorProtocol {
        dependenciesResolver.resolve(for: PLQuickBalanceCoordinatorProtocol.self)
    }

    private var getLastTransactionUseCase: GetLastTransactionProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

}

extension PLQuickBalancePresenter: PLQuickBalancePresenterProtocol {
    func viewDidLoad() {
        self.getInitialData()
    }
    
    func getInitialData() {
        view?.showLoader()
        Scenario(useCase: getLastTransactionUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                guard let self = self else { return }
                self.view?.hideLoader(completion: {
                    self.process(output: output)
                    return
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader() {
                    self?.handleServiceInaccessible()
                }
            }
    }
    
    func handleServiceInaccessible() {
        view?.showServiceInaccesible()
    }
    
    func pop() {
        coordinator.pop()
    }
    
    func showEnableQuickBalanceView() {
        coordinator.showEnableQuickBalanceView()
    }
    
}

extension PLQuickBalancePresenter {
    private func process(output: GetLastTransactionUseCaseOkOutput) {
        if output.dto.isEmpty == true {
            view?.showIntro()
        } else {
            view?.show(output: output)
        }
    }
}
