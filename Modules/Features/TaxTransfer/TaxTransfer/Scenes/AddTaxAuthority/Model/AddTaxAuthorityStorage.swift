//
//  AddTaxAuthorityStorage.swift
//  TaxTransfer
//
//  Created by 185167 on 24/03/2022.
//

import CoreFoundationLib

final class AddTaxAuthorityStorage {
    func getLastSelectedCities() throws -> [TaxAuthorityCity] {
        let citiesData = UserDefaults.standard.data(forKey: UserDefaultsKey.cities.rawValue)
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
        let taxAccountNumbersData = UserDefaults.standard.data(forKey: UserDefaultsKey.taxAccounts.rawValue)
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
        UserDefaults.standard.set(data, forKey: UserDefaultsKey.cities.rawValue)
    }
    
    func saveLastSelectedTaxAccountNumber(_ taxAccountNumber: String) throws {
        let currentlySavedTaxAccountNumbers = try getLastSelectedTaxAccountNumbers()
        let textToSave = getThreeLastSelectedItemsText(
            newItem: taxAccountNumber,
            currentlySavedItems: currentlySavedTaxAccountNumbers
        )
        let data = textToSave.data(using: String.Encoding.utf8)
        UserDefaults.standard.set(data, forKey: UserDefaultsKey.taxAccounts.rawValue)
    }
    
    private func getThreeLastSelectedItemsText(
        newItem: String,
        currentlySavedItems: [String]
    ) -> String {
        if currentlySavedItems.contains(newItem) {
            let savedItemsWithoutDuplicatedNewItem = currentlySavedItems.filter { $0 != newItem }
            return ([newItem] + savedItemsWithoutDuplicatedNewItem)
               .prefix(3)
               .joined(separator: String(encodedItemsSeparator))
        }
        
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
    enum UserDefaultsKey: String {
        case cities = "keychainTaxAuthorityCities"
        case taxAccounts = "keychainTaxAuthorityAccounts"
    }
    
    var encodedItemsSeparator: Character {
        return "|"
    }
}
