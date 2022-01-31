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

private extension PLPublicMenuRepository {
    func isTrustedDevice() -> Bool {
        let trustedDeviceManager = managerProvider.getTrustedDeviceManager()
        return trustedDeviceManager.getTrustedDeviceHeaders() != nil
    }
}
