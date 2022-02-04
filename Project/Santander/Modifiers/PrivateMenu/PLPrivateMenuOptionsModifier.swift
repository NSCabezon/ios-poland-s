//
//  PLPrivateMenuOptionsModifier.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 3/2/22.
//

import PrivateMenu
import OpenCombine
import CoreDomain

struct PLPrivateMenuOptionsModifier: GetPrivateMenuOptionsUseCase {
    private static var options: [PrivateMenuOptions] {
        let defaultOptions: [PrivateMenuOptions] = [.globalPosition,
                                                    .myProducts,
                                                    .transfers,
                                                    .blik,
                                                    .mobileAuthorization,
                                                    .productsAndOffers,
                                                    .currencyExchange,
                                                    .myHomeManager,
                                                    .member,
                                                    .contract,
                                                    .contract]
        return defaultOptions
    }
    func fetchMenuOptions() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        Just(getOptions()).eraseToAnyPublisher()
    }
}

private extension PLPrivateMenuOptionsModifier {
    func getOptions() -> [PrivateMenuOptionRepresentable] {
        let defOptions = PLPrivateMenuOptionsModifier.options.map { item in
            return PLPrivateMenuOption(imageKey: item.iconKey,
                                           titleKey: item.titleKey,
                                           extraMessageKey: "",
                                           newMessageKey: "",
                                           imageURL: nil,
                                           showArrow: item.submenuArrow,
                                           isHighlighted: item == .globalPosition ? true : false,
                                           type: item,
                                           isFeatured: false,
                                           accesibilityIdentifier: item.accessibilityIdentifier)
        }
        return defOptions
    }
}

struct PLPrivateMenuOption: PrivateMenuOptionRepresentable {
    var type: PrivateMenuOptions
    var imageKey: String
    var titleKey: String
    var extraMessageKey: String?
    var newMessageKey: String?
    var imageURL: String?
    var showArrow: Bool
    var isHighlighted: Bool
    var isFeatured: Bool
    var accesibilityIdentifier: String?
    
    init(imageKey: String,
         titleKey: String,
         extraMessageKey: String?,
         newMessageKey: String?,
         imageURL: String?,
         showArrow: Bool,
         isHighlighted: Bool,
         type: PrivateMenuOptions,
         isFeatured: Bool,
         accesibilityIdentifier: String?) {
        self.imageKey = imageKey
        self.titleKey = titleKey
        self.extraMessageKey = extraMessageKey
        self.newMessageKey = newMessageKey
        self.imageURL = imageURL
        self.showArrow = showArrow
        self.isHighlighted = isHighlighted
        self.type = type
        self.isFeatured = isFeatured
        self.accesibilityIdentifier = accesibilityIdentifier
    }
}
