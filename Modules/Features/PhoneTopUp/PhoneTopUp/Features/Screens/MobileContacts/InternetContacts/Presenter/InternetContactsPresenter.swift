//
//  InternetContactsPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/12/2021.
//

import CoreFoundationLib
import PLCommons
import PLUI
import SANPLLibrary
import SANLegacyLibrary

protocol InternetContactsPresenterProtocol: AnyObject {
    var view: InternetContactsViewProtocol? { get set }
    func didSelectBack()
    func didSelectClose()
    func getNumberOfSections() -> Int
    func headerTitle(forSection section: Int) -> Character
    func getNumberOfContacts(inSection section: Int) -> Int
    func getContact(for indexPath: IndexPath) -> MobileContact
    func didSelectContact(at indexPath: IndexPath)
    func didTouchPhoneContactsButton()
}

final class InternetContactsPresenter {
    // MARK: Properties
    
    private let dependenciesResolver: DependenciesResolver
    private let groupedContacts: GroupedMobileContacts
    weak var view: InternetContactsViewProtocol?
    private weak var coordinator: InternetContactsCoordinatorProtocol?
    private lazy var contactsPermissionHelper = dependenciesResolver.resolve(for: ContactsPermissionHelperProtocol.self)
    private lazy var getPhoneContactsUseCase = dependenciesResolver.resolve(for: GetContactsUseCaseProtocol.self)
    private lazy var useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
    private lazy var confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
    
    init(dependenciesResolver: DependenciesResolver, contacts: [MobileContact]) {
        self.dependenciesResolver = dependenciesResolver
        self.groupedContacts = dependenciesResolver.resolve(for: MobileContactsGrouping.self).groupContacts(contacts)
        coordinator = dependenciesResolver.resolve(for: InternetContactsCoordinatorProtocol.self)
    }
    
}

extension InternetContactsPresenter: InternetContactsPresenterProtocol {
    func didSelectBack() {
        coordinator?.back()
    }
    
    func didSelectClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator?.close()
        } declineAction: {}
        view?.showDialog(dialog)
    }
    
    func getNumberOfSections() -> Int {
        return groupedContacts.count
    }
    
    func getNumberOfContacts(inSection section: Int) -> Int {
        return groupedContacts[section].contacts.count
    }
    
    func getContact(for indexPath: IndexPath) -> MobileContact {
        return groupedContacts[indexPath.section].contacts[indexPath.row]
    }
    
    func headerTitle(forSection section: Int) -> Character {
        return groupedContacts[section].groupingCharacter
    }
    
    func didSelectContact(at indexPath: IndexPath) {
        let selectedContact = groupedContacts[indexPath.section].contacts[indexPath.row]
        coordinator?.didSelectContact(selectedContact)
    }
    
    func didTouchPhoneContactsButton() {
        contactsPermissionHelper.authorizeContactsUse { [weak self] isAuthorized in
            if isAuthorized {
                self?.showPhoneContacts()
            } else {
                self?.view?.showContactsPermissionsDeniedDialog()
            }
        }
    }
    
    private func showPhoneContacts() {
        Scenario(useCase: getPhoneContactsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.coordinator?.showPhoneContacts(output.contacts)
            }
    }
}
