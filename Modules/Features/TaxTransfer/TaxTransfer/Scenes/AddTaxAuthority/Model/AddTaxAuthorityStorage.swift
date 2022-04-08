//
//  AddTaxAuthorityStorage.swift
//  TaxTransfer
//
//  Created by 185167 on 24/03/2022.
//

import CoreFoundationLib

final class AddTaxAuthorityStorage {
    private let keychain = KeychainWrapper()
    private let compilation: CompilationProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.compilation = dependenciesResolver.resolve(for: CompilationProtocol.self)
    }
    
    func getLastSelectedCities() throws -> [TaxAuthorityCity] {
        let query = KeychainQuery(
            service: keychainService,
            account: KeychainAccount.cities.rawValue,
            accessGroup: compilation.keychain.sharedTokenAccessGroup
        )
        let citiesData = try KeychainWrapper().fetch(query: query) as? Data
        guard
            let data = citiesData,
            let citiesText = String(data: data, encoding: .utf8)
        else {
            return []
        }
        return getLastSelectedItems(fromJoinedText: citiesText).map {
            return TaxAuthorityCity(cityName: $0)
        }
    }
    
    func getLastSelectedTaxAccountNumbers() throws -> [String] {
        let query = KeychainQuery(
            service: keychainService,
            account: KeychainAccount.taxAccounts.rawValue,
            accessGroup: compilation.keychain.sharedTokenAccessGroup
        )
        let taxAccountNumbersData = try KeychainWrapper().fetch(query: query) as? Data
        guard
            let data = taxAccountNumbersData,
            let taxAccountNumbersText = String(data: data, encoding: .utf8)
        else {
            return []
        }
        return getLastSelectedItems(fromJoinedText: taxAccountNumbersText)
    }
    
    func saveLastSelectedCity(_ city: TaxAuthorityCity) throws {
        let currentlySavedCities = try getLastSelectedCities()
        let textToSave = getThreeLastSelectedItemsText(
            newItem: city.cityName,
            currentlySavedItems: currentlySavedCities.map { $0.cityName }
        )
        let data = textToSave.data(using: String.Encoding.utf8)
        let query = KeychainQuery(
            service: keychainService,
            account: KeychainAccount.cities.rawValue,
            accessGroup: compilation.keychain.sharedTokenAccessGroup,
            data: data as NSCoding?
        )
        try KeychainWrapper().save(query: query)
    }
    
    func saveLastSelectedTaxAccountNumber(_ taxAccountNumber: String) throws {
        let currentlySavedTaxAccountNumbers = try getLastSelectedTaxAccountNumbers()
        let textToSave = getThreeLastSelectedItemsText(
            newItem: taxAccountNumber,
            currentlySavedItems: currentlySavedTaxAccountNumbers
        )
        let data = textToSave.data(using: String.Encoding.utf8)
        let query = KeychainQuery(
            service: keychainService,
            account: KeychainAccount.taxAccounts.rawValue,
            accessGroup: compilation.keychain.sharedTokenAccessGroup,
            data: data as NSCoding?
        )
        try KeychainWrapper().save(query: query)
    }
    
    private func getThreeLastSelectedItemsText(
        newItem: String,
        currentlySavedItems: [String]
    ) -> String {
        return ([newItem] + currentlySavedItems)
           .prefix(3)
           .joined(separator: String(encodedItemsSeparator))
    }
    
    private func getLastSelectedItems(fromJoinedText text: String) -> [String] {
        return text
            .split(separator: encodedItemsSeparator)
            .map { String($0) }
    }
}

extension AddTaxAuthorityStorage {
    var keychainService: String {
        return "Santander"
    }
    
    enum KeychainAccount: String {
        case cities = "keychainTaxAuthorityCities"
        case taxAccounts = "keychainTaxAuthorityAccounts"
    }
    
    var encodedItemsSeparator: Character {
        return "|"
    }
}
