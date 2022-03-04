//
//  PLCardsHomeModuleCoordinatorApplePay.swift
//  Santander
//
//  Created by 185998 on 16/02/2022.
//

import Cards
import SANLegacyLibrary
import CoreFoundationLib
import RetailLegacy
import PLLegacyAdapter
import SANPLLibrary
import PassKit

protocol PLCardsHomeModuleCoordinatorApplePayProtocol {
    func didSelectAddToApplePay(card: CardEntity?)
}

class PLCardsHomeModuleCoordinatorApplePay {
    let dependenciesEngine: DependenciesDefault
    let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setupDependencies()
    }

    private func setupDependencies() {
        self.dependenciesEngine.register(for: PLAddToApplePayConfirmationUseCase.self) { dependenciesResolver in
            return PLAddToApplePayConfirmationUseCase(dependenciesResolver: dependenciesResolver)
        }
    }
}

extension PLCardsHomeModuleCoordinatorApplePay: PLCardsHomeModuleCoordinatorApplePayProtocol {
    func didSelectAddToApplePay(card: CardEntity?) {

        guard
            let card = card,
            let cardID = card.dto.contract?.contractNumber
        else {
            return
        }

        if let sufix = cardID.substring(ofLast: 4), PKPassLibrary().containsActivatedPaymentPass(primaryAccountNumberSuffix: sufix) {
            return
        }

        let result = try? self.dependenciesResolver
            .resolve(for: PLManagersProviderProtocol.self)
            .getCardsManager()
            .getCardDetail(cardId: cardID)

        let virtualPan: String
        let cardholderName: String

        switch result {
        case .success(let cardDetailDTO):
            virtualPan = cardDetailDTO.virtualPan ?? cardID
            cardholderName = cardDetailDTO.emboss1 + " " + cardDetailDTO.emboss2
        default:
            virtualPan = cardID
            cardholderName = ""
        }

        dependenciesResolver
            .resolve(for: PLApplePayEnrollmentManagerProtocol.self)
            .enroll(virtualPan: virtualPan,
                    cardholderName: cardholderName)

    }
}
