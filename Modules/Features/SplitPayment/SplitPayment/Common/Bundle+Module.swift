import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: SplitPaymentModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "SplitPayment", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
