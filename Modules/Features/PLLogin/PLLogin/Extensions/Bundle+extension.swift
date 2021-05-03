import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: PLLoginModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "PLLogin", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
