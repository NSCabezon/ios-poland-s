//
//  InternetContactsPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/12/2021.
//

import Commons
import PLCommons
import Commons
import PLUI
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

protocol InternetContactsPresenterProtocol: AnyObject {
    var view: InternetContactsViewProtocol? { get set }
    func didSelectBack()
    func getNumberOfSections() -> Int
    func headerTitle(forSection section: Int) -> Character
    func getNumberOfContacts(inSection section: Int) -> Int
    func getContact(for indexPath: IndexPath) -> MobileContact
    func didSelectContact(at indexPath: IndexPath)
}

final class InternetContactsPresenter {
    // MARK: Properties
    
    private let dependenciesResolver: DependenciesResolver
    private let groupedContacts: GroupedMobileContacts
    weak var view: InternetContactsViewProtocol?
    private weak var coordinator: InternetContactsCoordinatorProtocol?
    
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
}
