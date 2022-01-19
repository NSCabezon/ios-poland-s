import Foundation
import CoreFoundationLib
import OpenCombine
import Menu
import SANPLLibrary

final class PLPublicMenuRepository: PublicMenuRepository {
    
    private var managerProvider: PLManagersProviderProtocol
    
    init(_ managerProvider: PLManagersProviderProtocol) {
        self.managerProvider = managerProvider
    }
    
    func getPublicMenuConfiguration() -> AnyPublisher<[[PublicMenuElementRepresentable]], Never> {
        return Just(PLPublicMenuConfiguration(isTrustedDevice()).items).eraseToAnyPublisher()
    }
}

public enum PLCustomActions: String {
    case otherUser
    case information
    case service
    case offer
    case mobileAuthorization
}

private extension PLPublicMenuRepository {
    func isTrustedDevice() -> Bool {
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        return trustedDeviceManager.getTrustedDeviceHeaders() != nil
    }
}

private struct PLPublicMenuConfiguration {
    
    private let contactNumber = "+48 61 811 99 99"
    
    private let otherUserItem = PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                 titleKey: KindOfPublicMenuNode.otherUserViewModel.titleKey,
                                                 iconKey: KindOfPublicMenuNode.otherUserViewModel.iconKey,
                                                 action: .custom(action: PLCustomActions.otherUser.rawValue),
                                                 accessibilityIdentifier: KindOfPublicMenuNode.otherUserViewModel.accessibility,
                                                 type: .smallButton(style: PLSmallButtonType()))

    private lazy var informationItem = PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                        titleKey: KindOfPublicMenuNode.informationViewModel.titleKey,
                                                        iconKey: KindOfPublicMenuNode.informationViewModel.iconKey,
                                                        action: .custom(action: PLCustomActions.information.rawValue),
                                                        accessibilityIdentifier: KindOfPublicMenuNode.informationViewModel.accessibility,
                                                        type: (self.trustedDevice ? .smallButton(style: PLSmallButtonType()) : .bigButton(style: PLBigButtonType(fontSize: 20.0))))

    private lazy var firstItem = MenuOption(top: (self.trustedDevice ? otherUserItem : informationItem),
                                            bottom: (self.trustedDevice ? informationItem : nil))
    
    private let serviceItem = MenuOption(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                               titleKey: KindOfPublicMenuNode.serviceViewModel.titleKey,
                                                               iconKey: KindOfPublicMenuNode.serviceViewModel.iconKey,
                                                               action: .custom(action: PLCustomActions.service.rawValue),
                                                               accessibilityIdentifier: KindOfPublicMenuNode.serviceViewModel.accessibility,
                                                               type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                         bottom: nil)
    
    private let atmItem = MenuOption(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                           titleKey: KindOfPublicMenuNode.plATMViewModel.titleKey,
                                                           iconKey: KindOfPublicMenuNode.plATMViewModel.iconKey,
                                                           action: .goToATMLocator,
                                                           accessibilityIdentifier: KindOfPublicMenuNode.plATMViewModel.accessibility,
                                                           type: .atm(bgImage: "imgAtmMenu")),
                                     bottom: nil)
    
    private let offerItem = MenuOption(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                             titleKey: KindOfPublicMenuNode.offerViewModel.titleKey,
                                                             iconKey: KindOfPublicMenuNode.offerViewModel.iconKey,
                                                             action: .custom(action: PLCustomActions.offer.rawValue),
                                                             accessibilityIdentifier: KindOfPublicMenuNode.offerViewModel.accessibility,
                                                             type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                       bottom: nil)
    
    private lazy var contactItem = MenuOption(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                               titleKey: KindOfPublicMenuNode.contactViewModel.titleKey,
                                                               iconKey: KindOfPublicMenuNode.contactViewModel.iconKey,
                                                               action: .callPhone(number: contactNumber),
                                                               accessibilityIdentifier: KindOfPublicMenuNode.contactViewModel.accessibility,
                                                               type: .bigButton(style: PLBigButtonType(fontSize: 20.0))),
                                         bottom: nil)
    
    private let mobileAuthorizationItem = MenuOption(top: PublicMenuOption(kindOfNode: KindOfPublicMenuNode.none,
                                                                           titleKey: KindOfPublicMenuNode.mobileAuthorizationViewModel.titleKey,
                                                                           iconKey: KindOfPublicMenuNode.mobileAuthorizationViewModel.iconKey,
                                                                           action: .custom(action: PLCustomActions.mobileAuthorization.rawValue),
                                                                           accessibilityIdentifier: KindOfPublicMenuNode.mobileAuthorizationViewModel.accessibility,
                                                                           type: .smallButton(style: PLSmallButtonType())),
                                                     bottom: nil)
    private let rowNil = MenuOption(top: nil, bottom: nil)
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

private struct SelectOptionButtonModel: SelectOptionButtonModelRepresentable {
    public var titleKey: String
    public var action: PublicMenuAction
    public var node: KindOfPublicMenuNode
    public var accessibilityIdentifier: String?
}

private struct PublicMenuOption: PublicMenuOptionRepresentable {
    var kindOfNode: KindOfPublicMenuNode
    var titleKey: String
    var iconKey: String
    var action: PublicMenuAction
    var accessibilityIdentifier: String?
    var type: PublicMenuOptionType
    
    init(kindOfNode: KindOfPublicMenuNode,
         titleKey: String,
         iconKey: String,
         action: PublicMenuAction,
         accessibilityIdentifier: String?,
         type: PublicMenuOptionType) {
        self.kindOfNode = kindOfNode
        self.titleKey = titleKey
        self.iconKey = iconKey
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.type = type
    }
}

private struct MenuOption: PublicMenuElementRepresentable {
    var top: PublicMenuOptionRepresentable?
    var bottom: PublicMenuOptionRepresentable?
}

extension KindOfPublicMenuNode {
    static let otherUserViewModel = (titleKey: "pl_menuPublic_link_changeUser", iconKey: "icnChangeUser", accessibility: "btnOtherUser")
    static let informationViewModel = (titleKey: "pl_menuPublic_link_information", iconKey: "icnInfoRedLight", accessibility: "btnInfo")
    static let serviceViewModel = (titleKey: "pl_menuPublic_link_services", iconKey: "icnMcommerce", accessibility: "btnService")
    static let plATMViewModel = (titleKey: "menuPublic_link_checkAtm", iconKey: "icnMapPointSan", accessibility: "btnAtm")
    static let offerViewModel = (titleKey: "menuPublic_link_becomeClient", iconKey: "icnOffer", accessibility: "btnOffer")
    static let contactViewModel = (titleKey: "pl_menuPublic_link_emergency", iconKey: "icnPhoneRed", accessibility: "btnContact")
    static let mobileAuthorizationViewModel = (titleKey: "pl_menuPublic_link_mobileAuthorization", iconKey: "icnMobileAuthorization", accessibility: "btnMobileAuthorization")
}

private struct PLBigButtonType: BigButtonTypeRepresentable {
    public var font: UIFont
    public var lineBreakMode: NSLineBreakMode
    public var numberOfLines: Int
    public var minimumScaleFactor: CGFloat?
    
    init(fontSize: CGFloat) {
        self.font = UIFont.santander(size: fontSize)
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 2
        self.minimumScaleFactor = nil
    }
}

private struct PLSmallButtonType: SmallButtonTypeRepresentable {
    public var font: UIFont = .santander(size: 18)
}
