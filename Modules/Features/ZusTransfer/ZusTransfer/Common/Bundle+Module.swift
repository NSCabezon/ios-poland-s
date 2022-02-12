import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: ZusTransferModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "ZusTransfer", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
