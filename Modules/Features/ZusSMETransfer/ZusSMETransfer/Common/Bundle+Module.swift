import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: ZusSmeTransferDataLoaderCoordinator.self)
        let bundleURL = bundle.url(forResource: "ZusSmeTransfer", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
