//
//  PersonalAreaSectionsProvider.swift
//  Santander
//
//  Created by Rubén Márquez Fernández on 15/4/21.
//

import Commons
import PersonalArea


final class PersonalAreaSectionsProvider {
    
    private let dependenciesResolver: DependenciesResolver & DependenciesInjector
    private var reloadCompletion: ((Bool) -> Void)?
    
    
    init(dependenciesResolver: DependenciesResolver & DependenciesInjector) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PersonalAreaSectionsProvider: PersonalAreaSectionsProtocol {
    func getSecuritySectionCells(
        _ userPref: UserPrefWrapper?,
        completion: @escaping ([CellInfo]) -> Void) {
            
        let cells = PersonalAreaSectionsSecurityBuilder(userPref: userPref, resolver: dependenciesResolver)
                .addBiometryCell()
                .addGeoCell()
                .addSecureDeviceCell()
                .addOperativeUserCell()
                .addQuickBalanceCellPoland()
                .addChangePasswordCell()
                .addChangePINPoland()
                .addSignatureKeyCell()
                .addWayCommunicationPoland()
                .addCookiesSettingsPoland()
                .addEditGDPRCell()
                .addLastAccessCell()
                .build()
            completion(cells)
        }

    
}

private extension PersonalAreaSectionsProvider {
    var personalAreaCoordinator: PersonalAreaMainModuleCoordinatorDelegate? {
        self.dependenciesResolver.resolve(for: PersonalAreaMainModuleCoordinatorDelegate.self)
    }
}