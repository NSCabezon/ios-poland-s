//
//  ChangeAliasManager.swift
//  Santander
//
//  Created by Alvaro Royo on 7/1/22.
//

import Foundation
import Commons

class PLChangeAliasManager: ProductAliasManagerProtocol {
	
	func getProductAlias(for aliasType: ProductAlias.AliasType) -> ProductAlias? {
		let regExp = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyząęćółńśżźĄĘĆÓŁŃŚŻŹ-.:,;/& ")
		
		switch aliasType {
		case .cards: return ProductAlias(charSet: regExp, maxChars: 20)
		case .savings: return ProductAlias(charSet: regExp, maxChars: 40)
		case .accounts: return ProductAlias(charSet: regExp, maxChars: 40)
		case .loans: return ProductAlias(charSet: regExp, maxChars: 20)
		case .funds: return ProductAlias(charSet: regExp, maxChars: 40)
		}
	}
	
}
