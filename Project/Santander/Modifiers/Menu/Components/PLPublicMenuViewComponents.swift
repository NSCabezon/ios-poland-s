//
//  PLPublicMenuViewComponents.swift
//  Santander
//
//  Created by crodrigueza on 21/9/21.
//

import Foundation
import Menu
import Commons
import UI

final class PLPublicMenuViewComponents: PublicMenuViewComponents {
    public override init(resolver: DependenciesResolver) {
        super.init(resolver: resolver)
    }
    
    // MARK: - Buttons views
    func createOtherUserView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_changeUser"), iconKey: "icnChangeUser")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnOtherUser")
        let view = self.makeSmallButtonView(type)
        view.action = self.didPressOtherUserButton
        
        return view
    }
    
    func createInformationView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_information"), iconKey: "icnInfoRed")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnInformation")
        let view = self.makeSmallButtonView(type)
        view.action = self.setInformationButton
        
        return view
    }
    
    func createServicesView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_services"), iconKey: "icnMcommerce")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnServices")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didServicesButton
        
        return view
    }
    
    func createPLATMView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("menuPublic_link_checkAtm"), iconKey: "icnMapPointSan")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnAtm")
        let view = self.makeATMView(type)
        view.setViewModel(ATMMenuViewModel(backgroundImageName: "imgAtmMenu"))
        view.action = self.didPressPLATMButton
        
        return view
    }
    
    func createOfferView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("menuPublic_link_becomeClient"), iconKey: "icnOffer")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnOffer")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didPressOfferButton
        
        return view
    }
    
    func createContactView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_emergency"), iconKey: "icnPhoneRed")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnContact")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didPressContactButton
        
        return view
    }

    func createMobileAuthorizationView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_mobileAuthorization"), iconKey: "icnMobileAuthorization")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnMobileAuthorization")
        let view = self.makeSmallButtonView(type)
        view.action = self.didPressMobileAuthorizationButton
        
        return view
    }
}

private extension PLPublicMenuViewComponents {
    // MARK: - Buttons actions
    func didPressOtherUserButton() {
        showComingSoonMessage()
    }
    func setInformationButton() {
        showComingSoonMessage()
    }
    
    func didServicesButton() {
        showComingSoonMessage()
    }
    
    func didPressPLATMButton() {
        showComingSoonMessage()
    }
    
    func didPressOfferButton() {
        showComingSoonMessage()
    }
    
    func didPressContactButton() {
        showComingSoonMessage()
    }
    
    func didPressMobileAuthorizationButton() {
        showComingSoonMessage()
    }
    
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
