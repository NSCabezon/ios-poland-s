//
//  ChangeAliasManager.swift
//  Santander
//
//  Created by Alvaro Royo on 7/1/22.
//

import CoreFoundationLib
import CoreDomain

class PLChangeAliasManager: ProductAliasManagerProtocol {
	func getProductAlias(for aliasType: ProductTypeEntity) -> ProductAlias? {
		let regExp = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyząęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/& ")

		switch aliasType {
		case .card: return ProductAlias(charSet: regExp, maxChars: 20)
		case .deposit: return ProductAlias(charSet: regExp, maxChars: 40)
		case .account: return ProductAlias(charSet: regExp, maxChars: 40)
		case .loan: return ProductAlias(charSet: regExp, maxChars: 20)
		case .fund: return ProductAlias(charSet: regExp, maxChars: 40)
		default: return nil
		}
	}
}
