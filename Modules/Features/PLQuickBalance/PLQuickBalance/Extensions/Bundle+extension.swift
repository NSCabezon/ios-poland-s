import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: PLQuickBalanceCoordinator.self)
        let bundleURL = bundle.url(forResource: "PLQuickBalance", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
