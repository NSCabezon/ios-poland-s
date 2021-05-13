import Models
import Foundation

public protocol PLCompilationProtocol {
    var isEnvironmentsAvailable: Bool { get }
    var isTrustInvalidCertificateEnabled: Bool { get }
}

