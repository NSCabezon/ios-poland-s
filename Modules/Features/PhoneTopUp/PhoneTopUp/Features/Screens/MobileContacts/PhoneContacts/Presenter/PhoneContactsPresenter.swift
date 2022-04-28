//
//  PhoneContactsPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 10/01/2022.
//

import CoreFoundationLib
import PLCommons
import PLUI
import SANPLLibrary
import SANLegacyLibrary

protocol PhoneContactsPresenterProtocol: AnyObject {
    var view: PhoneContactsViewProtocol? { get set }
    func didSelectBack()
    func didSelectClose()
    func getNumberOfSections() -> Int
    func headerTitle(forSection section: Int) -> Character
    func getNumberOfContacts(inSection section: Int) -> Int
    func getContact(for indexPath: IndexPath) -> MobileContact
    func didSelectContact(at indexPath: IndexPath)
    func didUpdateQuery(to query: String)
}

final class PhoneContactsPresenter {
    // MARK: Properties
    
    weak var view: PhoneContactsViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private weak var coordinator: PhoneContactsCoordinatorProtocol?
    private lazy var contactsPermissionHelper = dependenciesResolver.resolve(for: ContactsPermissionHelperProtocol.self)
    private lazy var getPhoneContactsUseCase = dependenciesResolver.resolve(for: GetContactsUseCaseProtocol.self)
    private lazy var useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
    private lazy var searchFilter = dependenciesResolver.resolve(for: MobileContactsSearchFiltering.self)
    private lazy var confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
    private let allContacts: GroupedMobileContacts
    private var searchQuery = ""
    private var filteredContacts: GroupedMobileContacts {
        return searchFilter.filterContacts(allContacts, query: searchQuery)
    }
    
    init(dependenciesResolver: DependenciesResolver, contacts: [MobileContact]) {
        self.dependenciesResolver = dependenciesResolver
        let filteredContacts = dependenciesResolver.resolve(for: PolishContactsFiltering.self).filterAndFormatPolishContacts(contacts)
        self.allContacts = dependenciesResolver.resolve(for: MobileContactsGrouping.self).groupContacts(filteredContacts)
        coordinator = dependenciesResolver.resolve(for: PhoneContactsCoordinatorProtocol.self)
    }
    
}

extension PhoneContactsPresenter: PhoneContactsPresenterProtocol {
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
        return filteredContacts.count
    }
    
    func getNumberOfContacts(inSection section: Int) -> Int {
        return filteredContacts[section].contacts.count
    }
    
    func getContact(for indexPath: IndexPath) -> MobileContact {
        return filteredContacts[indexPath.section].contacts[indexPath.row]
    }
    
    func headerTitle(forSection section: Int) -> Character {
        return filteredContacts[section].groupingCharacter
    }
    
    func didSelectContact(at indexPath: IndexPath) {
        let selectedContact = filteredContacts[indexPath.section].contacts[indexPath.row]
        coordinator?.didSelectContact(selectedContact)
    }
    
    func didUpdateQuery(to query: String) {
        searchQuery = query
        view?.reloadData()
    }
}
