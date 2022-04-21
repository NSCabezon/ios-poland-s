//
//  QRTransferParser.swift
//  ScanAndPay
//
//  Created by 188216 on 21/03/2022.
//

import Foundation

/// Parses a string that adheres to the [2d code standard](https://zbp.pl/getmedia/1d7fef90-d193-4a2d-a1c3-ffdf1b0e0649/2013-12-03_-_Rekomendacja_-_Standard_2D)
final class QRTransferParser {
    // MARK: Properties
    
    private let numberOfComponents = 9
    private let supportedCountryCodes = ["PL"]
    private let numberOfCharactersInAccountNumber = 26
    
    // MARK: Methods
    
    func parse(string: String) -> QRTransferModel? {
        let components = string
            .split(separator: "|", omittingEmptySubsequences: false)
            .map(String.init)
        
        guard components.count == numberOfComponents else {
            return nil
        }
        
        let taxIdentifier = components[0]
        let countryCode = components[1]
        let accountNumber = components[2]
        let amountString = components[3]
        let recipientName = components[4]
        let transferTitle = components[5]
        let reserveField1 = components[6]
        let reserveField2 = components[7]
        let reserveField3 = components[8]
        
        guard supportedCountryCodes.contains(countryCode),
              accountNumber.count == numberOfCharactersInAccountNumber,
              accountNumber.allSatisfy(\.isNumber),
              amountString.allSatisfy(\.isNumber),
              !recipientName.isEmpty
        else {
            return nil
        }
        
        let amount = Int(amountString.trimmingLeadingCharacters(eqaulTo: "0"))
        
        return QRTransferModel(
            taxIdentifier: taxIdentifier,
            countryCode: countryCode,
            accountNumber: accountNumber,
            ammount: amount,
            recipientName: recipientName,
            transferTitle: transferTitle,
            reserveField1: reserveField1,
            reserveField2: reserveField2,
            reserveField3: reserveField3
        )
    }
}

extension String {
    func trimmingLeadingCharacters(eqaulTo character: Character) -> String {
        var results = self
        while results.first == character {
            results.removeFirst()
        }
        return results
    }
}
