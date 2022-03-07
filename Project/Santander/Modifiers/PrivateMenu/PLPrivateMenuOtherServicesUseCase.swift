//
//  PLPrivateMenuOtherServicesUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 7/3/22.
//

import OpenCombine
import PrivateMenu
import CoreDomain
import CoreFoundationLib

struct PLPrivateMenuOtherServicesUseCase: GetOtherServicesSubMenuUseCase {
    private let offers: GetCandidateOfferUseCase
    private let appConfig: AppConfigRepositoryProtocol
    private let globalPositionRepository: GlobalPositionDataRepository
    private let userPrefRepository: UserPreferencesRepository
    private let servicesForYou: ServicesForYouRepository

    init(dependencies: PrivateMenuModuleExternalDependenciesResolver) {
        offers = dependencies.resolve()
        appConfig = dependencies.resolve()
        globalPositionRepository = dependencies.resolve()
        userPrefRepository = dependencies.resolve()
        servicesForYou = ServicesForYouRepository(
            netClient: NetClientImplementation(),
            assetsClient: AssetsClient())
    }

    func fetchSubMenuOptions() -> AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        return otherServices
    }
}

private extension PLPrivateMenuOtherServicesUseCase {
    var otherServices: AnyPublisher<[PrivateMenuOptionRepresentable], Never> {
        let enableComingFeatures = appConfig
            .value(for: "enableComingFeatures", defaultValue: false)
        let locations = PullOffersLocationsFactoryEntity().privateMenuCarbonFootPrint
        let carbonFinger = isCandidate(locations)
        return enableComingFeatures
            .zip(carbonFinger, isSmartServicesEnabled) { features, carbon, smart -> [PrivateMenuOptionRepresentable] in
                var options: [PrivateMenuOtherServicesOptionType] = []
                if features {
                    options.append(.next)
                }
                if carbon {
                    options.append(.carbonFingerPrint)
                }
                if smart {
                    options.append(.smartServices)
                }
                return options
            }
            .eraseToAnyPublisher()
    }

    var isSmartServicesEnabled: AnyPublisher<Bool, Never> {
        return globalPositionRepository
            .getGlobalPosition()
            .map(\.userId)
            .flatMap { userId -> AnyPublisher<String, Error> in
                guard let userId = userId else { return Fail(error: NSError(description: "no-user-id")).eraseToAnyPublisher() }
                return Just(userId).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .map(userPrefRepository.getUserPreferences)
            .flatMap { $0 }
            .map { userPref in
                let smartServices = servicesForYou.get()
                let categoriesNotEmpty = smartServices?.categoriesRepresentable.isNotEmpty ?? false
                return userPref.isSmartUser() && categoriesNotEmpty
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }

    func isCandidate( _ locations: [PullOfferLocationRepresentable]) -> AnyPublisher<Bool, Never> {
        let result = locations.map(offers.fetchCandidateOfferPublisher).isNotEmpty
        return Just(result).eraseToAnyPublisher()
    }
}
