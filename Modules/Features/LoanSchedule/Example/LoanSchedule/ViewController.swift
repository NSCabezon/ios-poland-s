import UIKit
import UI
import LoanSchedule
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

class ViewController: UIViewController {
    
    private lazy var coordinator = LoanScheduleModuleCoordinator(
        dependenciesResolver: dependenciesResolver,
        navigationController: navigationController
    )
    private var mockData: LoanScheduleMockData = LoanScheduleMockData()
    private var timeManager: FakeTimeManager = FakeTimeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        UIStyle.setup()
    }
    
    private func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("Module Menu")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectClose() {} // Just to fix bug, it seems that at least one image must be loaded before calling UIStyle.setup()
    
    @IBAction func loanScheduleListTap(_ sender: Any) {
        mockData.state = .normal
        coordinator.start(with: LoanScheduleIdentity(
            loanAccountNumber: "1234",
            loanName: "Kredyt Hipoteczny"
        ))
    }
    
    @IBAction func emptyState(_ sender: Any) {
        mockData.state = .empty
        coordinator.start(with: LoanScheduleIdentity(
            loanAccountNumber: "1234",
            loanName: "Kredyt Hipoteczny"
        ))
    }
    
    internal lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: PLManagersProviderProtocol.self) { [unowned self]_ in
            return FakePLManagersProvider(mockData: self.mockData)
        }
        
        defaultResolver.register(for: TimeManager.self) { [unowned self] _ in
            return self.timeManager
        }
        return defaultResolver
    }()
}
