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
    var titleKey: String
    var icon: String?
    var submenuArrow: Bool
    var elementsCount: Int?
}

struct PLPrivateMenuMyProductsUseCase: GetMyProductSubMenuUseCase {
    private let boxes: GetGlobalPositionBoxesUseCase
    private let globalPositionRepository: GlobalPositionDataRepository
    private let offers: GetCandidateOfferUseCase
    
    let dictOptions: [PrivateMenuMyProductsOption: UserPrefBoxType] =
        [
            PrivateMenuMyProductsOption.accounts: UserPrefBoxType.account,
            PrivateMenuMyProductsOption.cards: UserPrefBoxType.card,
            PrivateMenuMyProductsOption.stocks: UserPrefBoxType.stock,
            PrivateMenuMyProductsOption.loans: UserPrefBoxType.loan,
            PrivateMenuMyProductsOption.deposits: UserPrefBoxType.deposit,
            PrivateMenuMyProductsOption.pensions: UserPrefBoxType.pension,
            PrivateMenuMyProductsOption.funds: UserPrefBoxType.fund,
            PrivateMenuMyProductsOption.insuranceSavings: UserPrefBoxType.insuranceSaving,
            PrivateMenuMyProductsOption.insuranceProtection: UserPrefBoxType.insuranceProtection
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
    var finalOptions: AnyPublisher<[PrivateMenuSectionRepresentable], Never> {
        return Publishers.Zip3(
            optionsMyProducts,
            boxes.fetchBoxesVisibles(),
            globalPositionRepository.getGlobalPosition())
            .map(buildOptions)
            .eraseToAnyPublisher()
    }
    
    var isPb: AnyPublisher<Bool, Never> {
        return globalPositionRepository
            .getGlobalPosition()
            .map(\.isPb)
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    var optionsMyProducts: AnyPublisher<[PrivateMenuMyProductsOption], Never> {
        return isPb
            .map { value in
                return value ? PrivateMenuMyProductsOption.pbOrder : PrivateMenuMyProductsOption.notPbOrder
            }
            .zip(isTPVLocations()) { previous, tpv in
                var final: [PrivateMenuMyProductsOption] = []
                final.append(contentsOf: previous)
                if tpv {
                    final.append(.tpvs)
                }
                return final
            }
            .eraseToAnyPublisher()
    }
    
    func isTPVLocations() -> AnyPublisher<Bool, Never> {
        let locations = PullOffersLocationsFactoryEntity().myProductsSideMenu
        return isCandidate(locations).eraseToAnyPublisher()
    }
    
    func buildOptions(_ options: [PrivateMenuMyProductsOption],
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
    
    func isCandidate( _ locations: [PullOfferLocationRepresentable]) -> AnyPublisher<Bool, Never> {
        let result = locations.map(offers.fetchCandidateOfferPublisher).isNotEmpty
        return Just(result).eraseToAnyPublisher()
    }
}

extension Array where Element == PrivateMenuMyProductsOption {
    func toOptionRepresentable(_ elementsCount: [PrivateMenuMyProductsOption: Int]) -> [PrivateSubMenuOptionRepresentable] {
        var result = [PrivateSubMenuOptionRepresentable]()
        self.forEach { option in
            let item = SubMenuElement(titleKey: option.titleKey,
                                         icon: option.imageKey,
                                         submenuArrow: false,
                                         elementsCount: elementsCount[option])
            result.append(item)
        }
        return result
    }
}

private extension PLPrivateMenuMyProductsUseCase {
    func howManyElementsIn(globalPosition: GlobalPositionDataRepresentable,
                           from myProducts: [PrivateMenuMyProductsOption]) -> [PrivateMenuMyProductsOption: Int] {
        var result = [PrivateMenuMyProductsOption: Int]()
        myProducts.forEach { option in
            result.updateValue(countForOption(option: option, in: globalPosition), forKey: option)
        }
        return result
    }
    
    func countForOption(option: PrivateMenuMyProductsOption, in globalPosition: GlobalPositionDataRepresentable) -> Int {
        switch option {
        case .accounts:
            return globalPosition.accountRepresentables.count
        case .cards:
            return globalPosition.cardRepresentables.count
        case .deposits:
            return globalPosition.depositRepresentables.count
        case .funds:
            return globalPosition.fundRepresentables.count
        case .insuranceProtection:
            return globalPosition.protectionInsuranceRepresentables.count
        case .insuranceSavings:
            return globalPosition.savingsInsuranceRepresentables.count
        case .loans:
            return globalPosition.loanRepresentables.count
        case .pensions:
            return globalPosition.pensionRepresentables.count
        case .stocks:
            return globalPosition.stockAccountRepresentables.count
        case .tpvs:
            return 0
        }
    }
}
