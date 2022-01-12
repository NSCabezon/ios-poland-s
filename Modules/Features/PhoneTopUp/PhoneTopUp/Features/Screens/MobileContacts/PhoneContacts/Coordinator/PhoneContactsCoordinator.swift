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
    func didSelectContact(_ contact: MobileContact)
}

final class PhoneContactsCoordinator: ModuleCoordinator {
    // MARK: Properties
    
    var navigationController: UINavigationController?
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
        dependenciesEngine.register(for: MobileContactsGrouping.self) { _ in
            return MobileContactsGrouper()
        }

        dependenciesEngine.register(for: PhoneContactsCoordinatorProtocol.self) { _ in
            return self
        }
    }
    
    // MARK: Methods
    
    public func start() {
        #warning("todo: this will be implemented in another PR")
        let contactsController = UIViewController()
        contactsController.view.backgroundColor = .white
        navigationController?.pushViewController(contactsController, animated: true)
    }
}

extension PhoneContactsCoordinator: PhoneContactsCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectContact(_ contact: MobileContact) {
        delegate?.mobileContactsDidSelectContact(contact)
    }
}
