//
//  PLLoginPullOfferLoader.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 17/11/21.
//

import Foundation
import Commons
import Models
import CoreFoundationLib
import CommonUseCase

final class PLLoginPullOfferLoader {
    
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesEngine.resolve(for: UseCaseHandler.self)
    }
    
    private var pullOfferCandidatesUseCase: PullOfferCandidatesUseCase {
        return self.dependenciesEngine.resolve(for: PullOfferCandidatesUseCase.self)
    }
    
    lazy var loadPullOffersSuperUseCase: SetupPublicPullOffersSuperUseCase = {
        return self.dependenciesEngine.resolve(for: SetupPublicPullOffersSuperUseCase.self)
    }()
    
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        
        self.dependenciesEngine.register(for: SetupPublicPullOffersSuperUseCase.self) { resolver in
           return SetupPublicPullOffersSuperUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: SetupPullOffersUseCase.self) { resolver in
           return SetupPullOffersUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: LoadPublicPullOffersVarsUseCase.self) { resolver in
           return LoadPublicPullOffersVarsUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: CalculateLocationsUseCase.self) { resolver in
           return CalculateLocationsUseCase(dependenciesResolver: resolver)
        }
    }
    
    func loadPullOffers() {
        self.loadPullOffersSuperUseCase.execute()
    }
}
