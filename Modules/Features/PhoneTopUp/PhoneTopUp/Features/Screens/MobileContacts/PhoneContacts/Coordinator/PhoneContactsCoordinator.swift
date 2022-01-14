//
//  PhoneContactsCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 05/01/2022.
//

import UI
import Commons
import PLCommons
import PLUI
import PLCommonOperatives

protocol PhoneContactsCoordinatorProtocol: AnyObject {
    func back()
    func close()
    func didSelectContact(_ contact: MobileContact)
}

final class PhoneContactsCoordinator: ModuleCoordinator {
    // MARK: Properties
    
    var navigationController: UINavigationController?
    private lazy var contactsController = dependenciesEngine.resolve(for: PhoneContactsViewController.self)
    private weak var delegate: MobileContactsSelectorDelegate?
    private let dependenciesEngine: DependenciesDefault
    private let contacts: [MobileContact]
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                delegate: MobileContactsSelectorDelegate?,
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
        dependenciesEngine.register(for: PolishContactsFiltering.self) { _ in
            return PolishContactsFilter()
        }
        
        dependenciesEngine.register(for: MobileContactsSearchFiltering.self) { resolver in
            return MobileContactsSearchFilter(contactsGrouper: resolver.resolve(for: MobileContactsGrouping.self))
        }
        
        dependenciesEngine.register(for: MobileContactsGrouping.self) { _ in
            return MobileContactsGrouper()
        }

        dependenciesEngine.register(for: PhoneContactsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: PhoneContactsPresenterProtocol.self) { [contacts] resolver in
            return PhoneContactsPresenter(dependenciesResolver: resolver, contacts: contacts)
        }
        
        dependenciesEngine.register(for: PhoneContactsViewController.self) { resolver in
            let presenter = resolver.resolve(for: PhoneContactsPresenterProtocol.self)
            let controller = PhoneContactsViewController(presenter: presenter)
            presenter.view = controller
            return controller
        }
    }
    
    // MARK: Methods
    
    public func start() {
        navigationController?.pushViewController(contactsController, animated: true)
    }
}

extension PhoneContactsCoordinator: PhoneContactsCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        delegate?.mobileContactDidSelectCloseProcess()
    }
    
    func didSelectContact(_ contact: MobileContact) {
        delegate?.mobileContactsDidSelectContact(contact)
    }
}
