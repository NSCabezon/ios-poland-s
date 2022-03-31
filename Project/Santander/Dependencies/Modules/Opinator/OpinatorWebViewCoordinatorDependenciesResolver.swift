import Operative

extension ModuleDependencies: OpinatorWebViewCoordinatorDependenciesResolver {
    func resolve() -> OperativeContainerCoordinatorDelegate {
        return oldResolver.resolve()
    }
}
