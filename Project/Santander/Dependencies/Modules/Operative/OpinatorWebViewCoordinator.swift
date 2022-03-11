import CoreFoundationLib
import RetailLegacy
import Operative
import UI


final class OpinatorWebViewCoordinator: BindableCoordinator {
    private let legacyDependenciesResolver: DependenciesResolver
    var dataBinding: DataBinding = DataBindingObject()
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var onFinish: (() -> Void)?
    
    init(dependencies: ModuleDependencies) {
        self.legacyDependenciesResolver = dependencies.resolve()
    }
    
    func start() {
        guard let info: OpinatorInfoRepresentable = dataBinding.get(),
              let completion: () -> Void = dataBinding.get()
        else { return }
        legacyDependenciesResolver.resolve(for: OperativeContainerCoordinatorDelegate.self).handleGiveUpOpinator(info, completion: completion)
    }
}
