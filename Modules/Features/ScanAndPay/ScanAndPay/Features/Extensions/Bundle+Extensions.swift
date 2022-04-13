
import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: ScanAndPayScannerCoordinator.self)
        let bundleURL = bundle.url(forResource: "ScanAndPay", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
