import Foundation
import CoreFoundationLib
import OpenCombine
import Menu

final class PLPublicMenuRepository: PublicMenuRepository {
    func getPublicMenuConfiguration() -> AnyPublisher<[[PublicMenuElementRepresentable]], Never> {
        return Just(DefaultPublicMenuConfiguration().items).eraseToAnyPublisher()
    }
}
