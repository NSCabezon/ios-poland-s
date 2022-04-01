//
//  PLCardHomeActionModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 5/7/21.
//

import Cards
import CoreFoundationLib
import UI
import CreditCardRepayment
import PLCommons
import PLCommonOperatives
import PersonalArea

final class PLCardHomeActionModifier: CardHomeActionModifier, CardBoardingActionModifierProtocol {
    
    override func getCreditCardHomeActions() -> [OldCardActionType] {
        return []
    }
    
    override func getDebitCardHomeActions() -> [OldCardActionType] {
        return []
    }
    
    override func didSelectAction(_ action: OldCardActionType, _ entity: CardEntity) {
        
        switch action {
        case .offCard:
            goToCardBlock(entity)
        case .onCard:
            goToCardUnblock(entity)
        case .applePay:
            goToApplePay(entity)
        case .custome(let values):
            guard let identifier = PLCardActionIdentifier.mapped(values.identifier) else { return }
            switch identifier {
            case .creditCardRepayment:
                openCreditCardRepayment(creditCardEntity: entity)
            case .changeAlias:
                goToPGProductsCustomization()
            case .addToPay:
                goToApplePay(entity)
            case .activate,
                    .multicurrency,
                    .managePin,
                    .useAbroad,
                    .modifyLimits,
                    .repayment,
                    .customerService,
                    .atmPackage,
                    .alerts24,
                    .viewStatements,
                    .cancelCard,
                    .creditLimitIncrease:
                self.openWebViewIfProceeds(for: identifier,
                                              entity: entity)
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }
            
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
    
    override func rearrangeApplePayAction() -> Bool {
        return false
    }
}

private extension PLCardHomeActionModifier {
    
    func getCardOperativesData(identifier: PLCardActionIdentifier) -> PLProductOperativesData? {
        
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.cardsOptions,
              let dto = (list.first { $0.id == identifier.rawValue }) else { return nil }
        return PLProductOperativesData(identifier: identifier.rawValue,
                                       link: dto.url,
                                       isAvailable: dto.isAvailable,
                                       httpMethod: dto.getHTTPMethod,
                                       isFullScreen: dto.isFullScreen)
    }
    
    func openWebViewIfProceeds(for identifier: PLCardActionIdentifier,
                               entity: CardEntity) {
        
        guard let cardData = self.getCardOperativesData(identifier: identifier),
              let isAvailable = cardData.isAvailable, isAvailable == true else {
                  Toast.show(localized("generic_alert_notAvailableOperation"))
                  return
              }
        self.showWebView(identifier: identifier,
                         entity: entity,
                         cardData: cardData)
        
    }
    
    func showWebView(identifier: PLCardActionIdentifier, entity: CardEntity, cardData: PLProductOperativesData) {
        switch identifier {
            
        case .managePin,
                .modifyLimits,
                .useAbroad,
                .activate,
                .customerService,
                .multicurrency:
            
            guard let url = cardData.link,
                  let vpan = entity.dto.contract?.contractNumber else {
                      Toast.show(localized("generic_alert_notAvailableOperation"))
                      return
                  }
            let useCase = self.dependenciesResolver.resolve(for: GetBasePLWebConfigurationUseCaseProtocol.self)
            let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url.replace("{$VPAN}", vpan), method: cardData.httpMethod ?? .get, isFullScreenEnabled: cardData.isFullScreen)
            Scenario(useCase: useCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { result in
                    let linkHandler = PLWebviewCustomLinkHandler(configuration: result.configuration)
                    let coordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
                    coordinator.showWebView(handler: linkHandler)
                }
        default:
            let input = GetPLCardsOtherOperativesWebConfigurationUseCaseInput(type: identifier, cardEntity: entity, cardData: cardData)
            let useCase = self.dependenciesResolver.resolve(for: GetPLCardsOtherOperativesWebConfigurationUseCase.self)
            Scenario(useCase: useCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { result in
                    self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
                }
        }
    }
    
    func openCreditCardRepayment(creditCardEntity: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CreditCardRepaymentModuleCoordinator.self)
        coordinator.start(with: creditCardEntity)
    }
    
    func goToCardBlock(_ card: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self)
        coordinator.didSelectAction(.offCard, card)
    }
    
    func goToCardUnblock(_ card: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self)
        coordinator.didSelectAction(.onCard, card)
    }
    
    func goToPGProductsCustomization() {
        let coordinator = dependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }

    func goToApplePay(_ card: CardEntity) {
        let cardHomeCoordinator = dependenciesResolver.resolve(for: PLCardsHomeModuleCoordinatorApplePayProtocol.self)
        cardHomeCoordinator.didSelectAddToApplePay(card: card)
    }
}
