import CreditCardRepayment
import PersonalArea
import GlobalPosition

extension ModuleDependencies: OtherOperativesModifierDependenciesResolver {
    func resolve() -> PersonalAreaModuleCoordinator {
        return oldResolver.resolve()
    }
    
    func resolve() -> CreditCardRepaymentModuleCoordinator {
        return oldResolver.resolve()
    }

    func resolve() -> GlobalPositionModuleCoordinatorDelegate {
        return oldResolver.resolve()
    }
}
