import PersonalArea
import CoreFoundationLib
import UI

final class PLSecurityActionFactory {
    
    private let dependenciesResolver: DependenciesResolver
    private var safEnabled: Bool?
    private var reloadCompletion: ((Bool) -> Void)?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getActions(userPref: UserPrefWrapper?, offer: OfferEntity?, deviceState: ValidatedDeviceStateEntity, completion: @escaping ([SecurityActionViewModelProtocol]) -> Void) {
            guard let userPreference = userPref else {
                completion([])
                return
            }
            let views = PLSecurityActionBuilder(userPreference: userPreference)
                .addBiometrySystem(customAction: nil)
                .addGeolocation()
                .addQuickerBalance()
                .addChangePin()
                .addChangePassword()
                .build()
            completion(views)
        }
}

extension PLSecurityActionFactory: SecurityAreaActionProtocol { }

private extension PLSecurityActionFactory {
    var localAuthManager: LocalAuthenticationPermissionsManagerProtocol {
        return self.dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
    }
    var personalAreaCoordinator: PersonalAreaMainModuleCoordinatorDelegate? {
        self.dependenciesResolver.resolve(for: PersonalAreaMainModuleCoordinatorDelegate.self)
    }
    var sessionController: SessionResponseController {
        return self.dependenciesResolver.resolve()
    }
}
