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

struct PLPrivateMenuMyProductsUseCase: GetMyProductSubMenuUseCase {
    private let boxes: GetGlobalPositionBoxesUseCase
    private let globalPositionRepository: GlobalPositionDataRepository
    private let offers: GetCandidateOfferUseCase
    
    init(dependencies: PrivateMenuModuleExternalDependenciesResolver) {
        boxes = dependencies.resolve()
        globalPositionRepository = dependencies.resolve()
        offers = dependencies.resolve()
    }
    
    func fetchSubMenuOptions() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return finalOptions
    }
}
private extension PLPrivateMenuMyProductsUseCase {
    var finalOptions: AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return Publishers.Zip(
            optionsMyProducts,
            boxes.fetchBoxesVisibles())
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
                      _ boxes: [UserPrefBoxType]) -> [PrivateMenuMyProductsOption] {
        var finalOptions = options
        if boxes.contains(.account), let index = finalOptions.firstIndex(of: .accounts) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.card), let index = finalOptions.firstIndex(of: .cards) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.stock), let index = finalOptions.firstIndex(of: .stocks) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.loan), let index = finalOptions.firstIndex(of: .loans) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.deposit), let index = finalOptions.firstIndex(of: .deposits) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.pension), let index = finalOptions.firstIndex(of: .pensions) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.fund), let index = finalOptions.firstIndex(of: .funds) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.insuranceSaving), let index = finalOptions.firstIndex(of: .insuranceSavings) {
            finalOptions.remove(at: index)
        }
        if boxes.contains(.insuranceProtection), let index = finalOptions.firstIndex(of: .insuranceProtection) {
            finalOptions.remove(at: index)
        }
        return finalOptions
    }
    
    func isCandidate( _ locations: [PullOfferLocationRepresentable]) -> AnyPublisher<Bool, Never> {
        let result = locations.map(offers.fetchCandidateOfferPublisher).isNotEmpty
        return Just(result).eraseToAnyPublisher()
    }
}
