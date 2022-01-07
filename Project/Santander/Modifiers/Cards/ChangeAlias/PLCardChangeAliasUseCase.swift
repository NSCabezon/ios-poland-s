//
//  PLCardChangeAliasUseCase.swift
//  Santander
//
//  Created by Alvaro Royo on 7/1/22.
//

import Foundation
import Cards
import Commons
import CoreFoundationLib
import SANLegacyLibrary

class PLCardChangeAliasUseCase: UseCase<CardChangeAliasUseCaseInput, Void, StringErrorOutput>, CardChangeAliasUseCaseProtocol {
	private let dependenciesResolver: DependenciesResolver
	
	init(dependenciesResolver: DependenciesResolver) {
		self.dependenciesResolver = dependenciesResolver
	}
	
	override func executeUseCase(requestValues: CardChangeAliasUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
//		let provider = self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
//
//
//
//		let response = try provider.getBsanCardsManager().changeCardAlias(cardDTO: requestValues.card.dto, newAlias: requestValues.newAlias)
//		guard response.isSuccess() else {
//			return UseCaseResponse.error(StringErrorOutput(try response.getErrorMessage()))
//		}
//		guard ChangeAliasManager.checkAlias(requestValues.newAlias, from: .cards) else {
//			return .error(StringErrorOutput("Please enter an alias with a maximum of “maximum nº of characters for this specific product” characters"))
//		}
		return .ok()
	}
	
}
