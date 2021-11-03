import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: LoanScheduleModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "LoanSchedule", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
