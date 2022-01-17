//
//  PhoneContactsPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 10/01/2022.
//

import Commons
import PLCommons
import Commons
import PLUI
import CoreFoundationLib
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
    private var groupedContacts: GroupedMobileContacts {
        return searchFilter.filterContacts(allContacts, query: searchQuery)
    }
    private let allContacts: GroupedMobileContacts
    private weak var coordinator: PhoneContactsCoordinatorProtocol?
    private lazy var searchFilter = dependenciesResolver.resolve(for: MobileContactsSearchFiltering.self)
    private var searchQuery = ""
    
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
        coordinator?.close()
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
    
    func didUpdateQuery(to query: String) {
        searchQuery = query
        view?.reloadData()
    }
}
