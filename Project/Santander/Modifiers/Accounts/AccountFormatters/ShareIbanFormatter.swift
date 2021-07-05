//
//  ShareIbanFormatter.swift
//  Santander
//
//  Created by Jose Javier Montes Romero on 12/4/21.
//

import Foundation
import Models
import Commons

class ShareIbanFormatter: ShareIbanFormatterProtocol {
    func ibanPapel(_ iban: IBANEntity?) -> String {
        return PLAccountNumberFormatter().getIBANFormatted(iban)
    }
    
    func shareAccountNumber(_ account: AccountEntity) -> String {
        return PLAccountNumberFormatter().getIBANFormatted(account.getIban())
    }
}
