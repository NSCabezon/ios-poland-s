//
//  PLPrivateMenuMyProductsUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 7/3/22.
//

import PrivateMenu
import OpenCombine
import CoreDomain
import CoreFoundationLib

struct PrivateMenuSection: PrivateMenuSectionRepresentable {
    let titleKey: String?
    let items: [PrivateSubMenuOptionRepresentable]
    
    public init(titleKey: String? = nil, items: [PrivateSubMenuOptionRepresentable]) {
        self.titleKey = titleKey
        self.items = items
    }
}

struct SubMenuElement: CoreDomain.PrivateSubMenuOptionRepresentable {
    let titleKey: String
    let icon: String?
    let submenuArrow: Bool
    let elementsCount: Int?
    let action: PrivateSubmenuAction
}

struct PLPrivateMenuMyProductsUseCase: GetMyProductSubMenuUseCase {
    private let boxes: GetGlobalPositionBoxesUseCase
    private let globalPositionRepository: GlobalPositionDataRepository
    private let offers: GetCandidateOfferUseCase
    private let dictOptions: [PrivateSubmenuAction: UserPrefBoxType] =
    [
        PrivateSubmenuAction.myProductOffer(.accounts): UserPrefBoxType.account,
        PrivateSubmenuAction.myProductOffer(.cards): UserPrefBoxType.card,
        PrivateSubmenuAction.myProductOffer(.stocks): UserPrefBoxType.stock,
        PrivateSubmenuAction.myProductOffer(.loans): UserPrefBoxType.loan,
        PrivateSubmenuAction.myProductOffer(.deposits): UserPrefBoxType.deposit,
        PrivateSubmenuAction.myProductOffer(.pensions): UserPrefBoxType.pension,
        PrivateSubmenuAction.myProductOffer(.funds): UserPrefBoxType.fund,
        PrivateSubmenuAction.myProductOffer(.insuranceSavings): UserPrefBoxType.insuranceSaving,
        PrivateSubmenuAction.myProductOffer(.insuranceProtection): UserPrefBoxType.insuranceProtection
    ]
    
    init(dependencies: PrivateMenuModuleExternalDependenciesResolver) {
        boxes = dependencies.resolve()
        globalPositionRepository = dependencies.resolve()
        offers = dependencies.resolve()
    }
    
    func fetchSubMenuOptions() -> AnyPublisher<[PrivateMenuSectionRepresentable], Never> {
        return finalOptions
    }
}

private extension PLPrivateMenuMyProductsUseCase {
    static var options: [PrivateSubmenuAction] {
        let defaultOptions: [PrivateSubmenuAction] =
        [
            .myProductOffer(.accounts),
            .myProductOffer(.cards),
            .myProductOffer(.deposits),
            .myProductOffer(.loans),
            .myProductOffer(.stocks),
            .myProductOffer(.pensions),
            .myProductOffer(.funds),
            .myProductOffer(.insuranceSavings),
            .myProductOffer(.insuranceProtection)
        ]
        return defaultOptions
    }
}

private extension PLPrivateMenuMyProductsUseCase {
    var finalOptions: AnyPublisher<[PrivateMenuSectionRepresentable], Never> {
        return Publishers.Zip3(
            optionsMyProducts,
            boxes.fetchBoxesVisibles(),
            globalPositionRepository.getGlobalPosition())
            .map(buildOptions)
            .eraseToAnyPublisher()
    }
    
    var optionsMyProducts: AnyPublisher<[PrivateSubmenuAction], Never> {
        Just(PLPrivateMenuMyProductsUseCase.options).eraseToAnyPublisher()
    }
    
    func buildOptions(_ options: [PrivateSubmenuAction],
                      _ boxes: [UserPrefBoxType],
                      _ globalPosition: GlobalPositionDataRepresentable) -> [PrivateMenuSectionRepresentable] {
        let finalOptions = options.filter { option in
            guard let boxOption = dictOptions[option] else { return false }
            return boxes.contains(boxOption)
        }
        let countedElements = howManyElementsIn(globalPosition: globalPosition, from: finalOptions)
        let section = PrivateMenuSection(items: finalOptions.toOptionRepresentable(countedElements))
        return [section]
    }
    
    func isLocation(_ location: String) -> AnyPublisher<OfferRepresentable, Never> {
        guard let location = PullOffersLocationsFactoryEntity()
                .getLocationRepresentable(
                    locations: PullOffersLocationsFactoryEntity().myProductsSideMenu,
                    location: location) else {
                        return Just(EmptyOffer()).eraseToAnyPublisher() }
        return isCandidate(location).eraseToAnyPublisher()
    }
    
    func isCandidate( _ location: PullOfferLocationRepresentable) -> AnyPublisher<OfferRepresentable, Never> {
        return offers
            .fetchCandidateOfferPublisher(location: location)
            .catch { _ in Just(EmptyOffer()).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}

extension Array where Element == PrivateSubmenuAction {
    func isNotEmptyOffer(_ offer: OfferRepresentable?) -> Bool {
        guard let offer = offer, offer is EmptyOffer else { return true }
        return false
    }
    
    func toOptionRepresentable(_ elementsCount: [PrivateSubmenuAction: Int]? = nil) -> [PrivateSubMenuOptionRepresentable] {
        var result = [PrivateSubMenuOptionRepresentable]()
        self.forEach { option in
            if case .myProductOffer(let product, let offer) = option {
                guard let elementsCount = elementsCount, isNotEmptyOffer(offer) else { return }
                let item = SubMenuElement(titleKey: product.titleKey,
                                          icon: product.imageKey,
                                          submenuArrow: false,
                                          elementsCount: elementsCount[option],
                                          action: option)
                result.append(item)
            }
        }
        return result
    }
}

private extension PLPrivateMenuMyProductsUseCase {
    func howManyElementsIn(globalPosition: GlobalPositionDataRepresentable,
                           from myProducts: [PrivateSubmenuAction]) -> [PrivateSubmenuAction: Int] {
        var result = [PrivateSubmenuAction: Int]()
        myProducts.forEach { option in
            result.updateValue(countForOption(option: option, in: globalPosition), forKey: option)
        }
        return result
    }
    
    func countForOption(option: PrivateSubmenuAction,
                        in globalPosition: GlobalPositionDataRepresentable) -> Int {
        let representablesDictionary: [PrivateMenuMyProductsOption: Int] =
        [
            .accounts: globalPosition.accountRepresentables.count,
            .cards: globalPosition.accountRepresentables.count,
            .deposits: globalPosition.accountRepresentables.count,
            .funds: globalPosition.accountRepresentables.count,
            .insuranceProtection: globalPosition.accountRepresentables.count,
            .insuranceSavings: globalPosition.accountRepresentables.count,
            .loans: globalPosition.accountRepresentables.count,
            .pensions: globalPosition.accountRepresentables.count,
            .stocks: globalPosition.accountRepresentables.count
        ]
        switch option {
        case .myProductOffer(let product, _):
            return representablesDictionary[product] ?? .zero
        default: return .zero
        }
    }
}

struct EmptyOffer: OfferRepresentable {
    let pullOfferLocation: PullOfferLocationRepresentable?
    let bannerRepresentable: BannerRepresentable?
    let action: OfferActionRepresentable?
    let id: String?
    let identifier: String
    let transparentClosure: Bool
    let productDescription: String
    let rulesIds: [String]
    let startDateUTC: Date?
    let endDateUTC: Date?
    
    init() {
        self.identifier = "EmptyOffer"
        self.transparentClosure = false
        self.productDescription = ""
        self.rulesIds = []
        self.pullOfferLocation = nil
        self.bannerRepresentable = nil
        self.startDateUTC = nil
        self.endDateUTC = nil
        self.action = nil
        self.id = nil
    }
}

extension PrivateMenuSubmenuFooterOffer {
    func offers() -> [PullOfferLocationRepresentable] {
        switch self {
        case .myProducts:
            return PullOffersLocationsFactoryEntity().myProducts
        case .investments:
            return PullOffersLocationsFactoryEntity().investmentSubmenuOffers
        }
    }
}
