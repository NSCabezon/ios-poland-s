import CreditCardRepayment
import PersonalArea

extension ModuleDependencies: OtherOperativesModifierDependenciesResolver {
    func resolve() -> PersonalAreaModuleCoordinator {
        return oldResolver.resolve()
    }
    
    func resolve() -> CreditCardRepaymentModuleCoordinator {
        return oldResolver.resolve()
    }
}
