//
//  InternetContactsCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/12/2021.
//

import UI
import Commons
import PLCommons
import PLUI
import PLCommonOperatives

protocol InternetContactsCoordinatorProtocol: AnyObject {
    func back()
    func didSelectContact(_ contact: MobileContact)
}

protocol InternetContactsDelegate: AnyObject {
    func internetContactsDidSelectContact(_ contact: MobileContact)
}

final class InternetContactsCoordinator: ModuleCoordinator {
    // MARK: Properties
    
    var navigationController: UINavigationController?
    private weak var delegate: InternetContactsDelegate?
    private let dependenciesEngine: DependenciesDefault
    private let contacts: [MobileContact]
    private lazy var internetContactsController = {
        return dependenciesEngine.resolve(for: InternetContactsViewController.self)
    }()
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                delegate: InternetContactsDelegate?,
                navigationController: UINavigationController?,
                contacts: [MobileContact]) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.delegate = delegate
        self.contacts = contacts
        self.setUpDependencies()
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies() {
        dependenciesEngine.register(for: MobileContactsGrouping.self) { _ in
            return MobileContactsGrouper()
        }

        dependenciesEngine.register(for: InternetContactsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: InternetContactsPresenterProtocol.self) { [contacts] resolver in
            return InternetContactsPresenter(dependenciesResolver: resolver, contacts: contacts)
        }
        
        dependenciesEngine.register(for: InternetContactsViewController.self) { resolver in
            let presenter = resolver.resolve(for: InternetContactsPresenterProtocol.self)
            let controller = InternetContactsViewController(presenter: presenter)
            presenter.view = controller
            return controller
        }
    }
    
    // MARK: Methods
    
    public func start() {
        navigationController?.pushViewController(internetContactsController, animated: true)
    }
}

extension InternetContactsCoordinator: InternetContactsCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectContact(_ contact: MobileContact) {
        delegate?.internetContactsDidSelectContact(contact)
    }
}
