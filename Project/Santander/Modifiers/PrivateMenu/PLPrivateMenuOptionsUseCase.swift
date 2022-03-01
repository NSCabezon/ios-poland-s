//
//  PLPrivateMenuOptionsUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 3/2/22.
//

import PrivateMenu
import OpenCombine
import CoreDomain

struct PLPrivateMenuOptionsUseCase: GetPrivateMenuOptionsUseCase {
    private let featuredOptionsUseCase: GetFeaturedOptionsUseCase
    private let enabledOptionsUseCase: GetPrivateMenuOptionEnabledUseCase
    
    init(dependencies: PrivateMenuExternalDependenciesResolver) {
        featuredOptionsUseCase = dependencies.resolve()
        enabledOptionsUseCase = dependencies.resolve()
    }
    
    func fetchMenuOptions() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return availableOptionsPublisher()
    }
}

extension PLPrivateMenuOptionsUseCase {
    private static var options: [PrivateMenuOptions] {
        let defaultOptions: [PrivateMenuOptions] =
        [
            .globalPosition,
            .myProducts,
            .transfers,
            .blik,
            .mobileAuthorization,
            .becomeClient,
            .currencyExchange,
            .services,
            .memberGetMember
        ]
        return defaultOptions
    }
}

private extension PLPrivateMenuOptionsUseCase {
    func menuOptionPublisher() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return featuredOptionsUseCase
            .fetchFeaturedOptions()
            .map(buildOptions)
            .eraseToAnyPublisher()
    }
    
    func enabledOptionsPublisher() -> AnyPublisher<[PrivateMenuOptions], Never> {
        return enabledOptionsUseCase
            .fetchOptionsEnabledVisible()
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    func availableOptionsPublisher() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return Publishers.Zip(
            menuOptionPublisher(),
            enabledOptionsPublisher()
        )
            .map(buildEnabledOptions)
            .eraseToAnyPublisher()
    }
    
    func buildEnabledOptions(_ optionsRepresentable: [PrivateMenuOptionRepresentable],
                             _ notEnabled: [PrivateMenuOptions]) -> [PrivateMenuOptionRepresentable] {
        var availableOption = optionsRepresentable
        availableOption.removeIfFound { notEnabled.contains($0.type) }
        return availableOption
    }
    
    func evaluateFeaturedOptions(_ featuredOptions: [PrivateMenuOptions: String], with option: PrivateMenuOptions) -> (isFeatured: Bool, message: String) {
        guard let fOption = featuredOptions.filter({$0.key == option}).first else {
            return (false, "")
        }
        return (true, fOption.value)
    }
    
    func buildOptions(featuredOptions: [PrivateMenuOptions: String]) -> [PrivateMenuOptionRepresentable] {
        PLPrivateMenuOptionsUseCase.options.map { item in
            let optionEvaluator = evaluateFeaturedOptions(featuredOptions, with: item)
            return PrivateMenuMainOption(
                imageKey: item.iconKey,
                titleKey: item.titleKey,
                extraMessageKey: optionEvaluator.isFeatured ? optionEvaluator.message : "",
                newMessageKey: optionEvaluator.isFeatured ? "menu_label_newProminent" : "",
                imageURL: nil,
                showArrow: item.submenuArrow,
                isHighlighted: item == .globalPosition ? true : false,
                type: item,
                isFeatured: optionEvaluator.isFeatured,
                accesibilityIdentifier: item.accessibilityIdentifier
            )
        }
    }
    
    struct PrivateMenuMainOption: PrivateMenuOptionRepresentable, Hashable {
        let imageKey: String
        let titleKey: String
        let extraMessageKey: String?
        let newMessageKey: String?
        let imageURL: String?
        let showArrow: Bool
        let isHighlighted: Bool
        let type: PrivateMenuOptions
        let isFeatured: Bool
        let accesibilityIdentifier: String?
        
        init(item: PrivateMenuOptionRepresentable) {
            self.imageKey = item.imageKey
            self.titleKey = item.titleKey
            self.extraMessageKey = item.extraMessageKey
            self.newMessageKey = item.newMessageKey
            self.imageURL = item.imageURL
            self.showArrow = item.showArrow
            self.isHighlighted = item.isHighlighted
            self.type = item.type
            self.isFeatured = item.isFeatured
            self.accesibilityIdentifier = item.accesibilityIdentifier
        }
        
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
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(imageKey)
            hasher.combine(accesibilityIdentifier)
        }
        static func == (lhs: PrivateMenuMainOption, rhs: PrivateMenuMainOption) -> Bool {
            return lhs.imageKey == rhs.imageKey
        }
    }
}
