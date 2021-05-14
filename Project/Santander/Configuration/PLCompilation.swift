//
//  PLCompilation.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 14/5/21.
//

import Foundation
import PLCommons

struct PLCompilation: PLCompilationProtocol {
    var isEnvironmentsAvailable: Bool {
        return XCConfig["ENVIRONMENTS_AVAILABLE"] ?? false
    }
    var isTrustInvalidCertificateEnabled: Bool {
        return XCConfig["IS_TRUST_INVALID_CERTIFICATE_ENABLED"] ?? false
    }
}
