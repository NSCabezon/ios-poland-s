//
//  PLPublicMenuConfiguration.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 25/1/22.
//
import CoreFoundationLib

struct PLPublicMenuConfiguration {
    
    private let contactNumber = "+48 61 811 99 99"
    
    // TODO: - Replace the action with .custom(action: PLCustomActions.otherUser.rawValue) when will be available
    private let otherUserItem = PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                 titleKey: KindOfPublicMenuNode.otherUserViewModel.titleKey,
                                                 iconKey: KindOfPublicMenuNode.otherUserViewModel.iconKey,
                                                 action: .comingSoon,
                                                 accessibilityIdentifier: KindOfPublicMenuNode.otherUserViewModel.accessibility,
                                                 type: .smallButton(style: PLSmallButtonType()))
    
    // TODO: - Replace the action with .custom(action: PLCustomActions.information.rawValue) when will be available
    private lazy var informationItem = PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                        titleKey: KindOfPublicMenuNode.informationViewModel.titleKey,
                                                        iconKey: KindOfPublicMenuNode.informationViewModel.iconKey,
                                                        action: .comingSoon,
                                                        accessibilityIdentifier: KindOfPublicMenuNode.informationViewModel.accessibility,
                                                        type: (self.trustedDevice ? .smallButton(style: PLSmallButtonType()) : .bigButton(style: PLBigButtonType(fontSize: 20.0))))

    private lazy var firstItem = PublicMenuElement(top: (self.trustedDevice ? otherUserItem : informationItem),
                                            bottom: (self.trustedDevice ? informationItem : nil))
    
    // TODO: - Replace the action with .custom(action: PLCustomActions.service.rawValue) when will be available
    private let serviceItem = PublicMenuElement(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                               titleKey: KindOfPublicMenuNode.serviceViewModel.titleKey,
                                                               iconKey: KindOfPublicMenuNode.serviceViewModel.iconKey,
                                                               action: .comingSoon,
                                                               accessibilityIdentifier: KindOfPublicMenuNode.serviceViewModel.accessibility,
                                                               type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                         bottom: nil)
    
    // TODO: - Replace the action with .goToATMLocator when will be available
    private let atmItem = PublicMenuElement(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                           titleKey: KindOfPublicMenuNode.plATMViewModel.titleKey,
                                                           iconKey: KindOfPublicMenuNode.plATMViewModel.iconKey,
                                                           action: .comingSoon,
                                                           accessibilityIdentifier: KindOfPublicMenuNode.plATMViewModel.accessibility,
                                                           type: .atm(bgImage: "imgAtmMenu")),
                                     bottom: nil)
    // TODO: - Replace the action with .custom(action: PLCustomActions.offer.rawValue) when will be available
    private let offerItem = PublicMenuElement(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                             titleKey: KindOfPublicMenuNode.offerViewModel.titleKey,
                                                             iconKey: KindOfPublicMenuNode.offerViewModel.iconKey,
                                                             action: .comingSoon,
                                                             accessibilityIdentifier: KindOfPublicMenuNode.offerViewModel.accessibility,
                                                             type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                       bottom: nil)
    // TODO: - Replace the action with .callPhone(number: contactNumber) when will be available
    private lazy var contactItem = PublicMenuElement(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                               titleKey: KindOfPublicMenuNode.contactViewModel.titleKey,
                                                               iconKey: KindOfPublicMenuNode.contactViewModel.iconKey,
                                                               action: .comingSoon,
                                                               accessibilityIdentifier: KindOfPublicMenuNode.contactViewModel.accessibility,
                                                               type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                         bottom: nil)
    // TODO: - Replace the action with .custom(action: PLCustomActions.mobileAuthorization.rawValue) when will be available
    private let mobileAuthorizationItem = PublicMenuElement(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                                           titleKey: KindOfPublicMenuNode.mobileAuthorizationViewModel.titleKey,
                                                                           iconKey: KindOfPublicMenuNode.mobileAuthorizationViewModel.iconKey,
                                                                           action: .comingSoon,
                                                                           accessibilityIdentifier: KindOfPublicMenuNode.mobileAuthorizationViewModel.accessibility,
                                                                           type: .smallButton(style: PLSmallButtonType())),
                                                     bottom: nil)
    private let rowNil = PublicMenuElement(top: nil, bottom: nil)
    private let trustedDevice: Bool
    
    public var items: [[PublicMenuElementRepresentable]] = []
    
    public init(_ trustedDevice: Bool) {
        self.trustedDevice = trustedDevice
        let mobAuthElem = trustedDevice ? mobileAuthorizationItem : rowNil
        self.items = [
            [firstItem, serviceItem],
            [atmItem],
            [offerItem, contactItem],
            [mobAuthElem, rowNil]
        ]
    }
}
