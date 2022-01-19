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
import SANPLLibrary

final class PLPublicMenuViewComponents: PublicMenuViewComponents {
    private let resolver: DependenciesResolver
    let smallButtonTitleFont: UIFont = .santander(family: .text, type: .regular, size: 18)
    let bigButtonTitleFont: UIFont = .santander(family: .text, type: .regular, size: 20)

    public override init(resolver: DependenciesResolver) {
        self.resolver = resolver
        super.init(resolver: resolver)
    }
    
    // MARK: - Buttons views
    func createOtherUserView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_changeUser"), iconKey: "icnChangeUser", titleFont: smallButtonTitleFont)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnOtherUser")
        let view = self.makeSmallButtonView(type)
        view.action = self.didPressOtherUserButton
        
        return view
    }
    
    func createInformationView() -> UIView {
        let isTrustedDevice = isTrustedDevice()
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_information"), iconKey: "icnInfoRedLight", titleFont: isTrustedDevice ? smallButtonTitleFont : bigButtonTitleFont)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnInformation")
        if isTrustedDevice {
            let view = self.makeSmallButtonView(type)
            view.action = self.setInformationButton

            return view
        }
        else {
            let view = self.makeBigButtonView(type, buttonType: .publicMenu)
            view.action = self.setInformationButton

            return view
        }
    }
    
    func createServicesView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_services"), iconKey: "icnMcommerce", titleFont: bigButtonTitleFont)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnServices")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didServicesButton
        
        return view
    }
    
    func createPLATMView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("menuPublic_link_checkAtm"), iconKey: "icnMapPointSan", titleFont: nil)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnAtm")
        let view = self.makeATMView(type)
        view.setViewModel(ATMMenuViewModel(backgroundImageName: "imgAtmMenu"))
        view.action = self.didPressPLATMButton
        
        return view
    }
    
    func createOfferView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("menuPublic_link_becomeClient"), iconKey: "icnOffer", titleFont: bigButtonTitleFont)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnOffer")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didPressOfferButton
        
        return view
    }
    
    func createContactView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_emergency"), iconKey: "icnPhoneRed", titleFont: bigButtonTitleFont)
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "btnContact")
        let view = self.makeBigButtonView(type, buttonType: .publicMenu)
        view.action = self.didPressContactButton
        
        return view
    }

    func createMobileAuthorizationView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: localized("pl_menuPublic_link_mobileAuthorization"), iconKey: "icnMobileAuthorization", titleFont: smallButtonTitleFont)
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
        performActionFor(phoneNumber: "+48 61 811 99 99")
    }
    
    func didPressMobileAuthorizationButton() {
        showComingSoonMessage()
    }
    
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

extension PLPublicMenuViewComponents: OpenUrlCapable {
    func performActionFor(phoneNumber: String) {
        let preFormattedPhoneNumber = phoneNumber.notWhitespaces()
        guard let phoneURL = URL(string: "tel://\(preFormattedPhoneNumber)"),
              canOpenUrl(phoneURL)
        else {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }
        openUrl(phoneURL)
    }
}

private extension PLPublicMenuViewComponents {
    func isTrustedDevice() -> Bool {
        let managerProvider: PLManagersProviderProtocol = self.resolver.resolve(for: PLManagersProviderProtocol.self)
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        return trustedDeviceManager.getTrustedDeviceHeaders() != nil
    }
}
