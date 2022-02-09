import UI
import CoreFoundationLib

public struct LoanScheduleIdentity {
    let loanAccountNumber: String
    let loanName: String
    
    public init(loanAccountNumber: String, loanName: String) {
        self.loanAccountNumber = loanAccountNumber
        self.loanName = loanName
    }
}

final public class LoanScheduleModuleCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let loanScheduleCoordinator: LoanScheduleListCoordinator
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.loanScheduleCoordinator = LoanScheduleListCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        setupDependencies()
    }
    
    public func start() {
        fatalError("This module need to be started with LoanScheduleIdentity")
    }
    
    public func start(with loanScheduleIdentity: LoanScheduleIdentity) {
        loanScheduleCoordinator.start(with: loanScheduleIdentity)
    }
}

private extension LoanScheduleModuleCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: LoanScheduleModuleCoordinator.self) { _ in
            return self
        }
    }
}
