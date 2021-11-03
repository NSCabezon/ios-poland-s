import UIKit
import UI
import PLNotificationsInbox
import Commons
import DomainCommon

class ViewController: UIViewController {
    
    private lazy var coordinator = PLNotificationsInboxModuleCoordinator(
        dependenciesResolver: dependenciesResolver,
        navigationController: navigationController
    )
    
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
    
    @IBAction func notificationsInboxTap(_ sender: Any) {
        coordinator.start()
    }
    
    internal lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        return defaultResolver
    }()
}
