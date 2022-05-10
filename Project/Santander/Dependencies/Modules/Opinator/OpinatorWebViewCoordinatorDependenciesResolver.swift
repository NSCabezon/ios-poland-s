import UI
import Operative

extension ModuleDependencies: OpinatorWebViewCoordinatorDependenciesResolver {
    func resolve() -> OperativeContainerCoordinatorDelegate {
        return oldResolver.resolve()
    }
    
    func opinatorCoordinator() -> BindableCoordinator {
       return OpinatorWebViewCoordinator(dependencies: self)
    }
}
