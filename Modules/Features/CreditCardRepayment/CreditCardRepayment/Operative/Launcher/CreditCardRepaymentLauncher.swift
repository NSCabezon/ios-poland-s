import Foundation
import Operative
import CoreFoundationLib
import CoreFoundationLib

protocol CreditCardRepaymentLauncher: OperativeContainerLauncher {
    func goToCreditCardRepayment(
        operativeData: CreditCardRepaymentOperativeData,
        handler: OperativeLauncherHandler
    )
}

extension CreditCardRepaymentLauncher {
    func goToCreditCardRepayment(
        operativeData: CreditCardRepaymentOperativeData,
        handler: OperativeLauncherHandler
    ) {
        let dependenciesEngine = DependenciesDefault(father: handler.dependenciesResolver)
        self.go(
            to: CreditCardRepaymentOperative(dependencies: dependenciesEngine),
            handler: handler,
            operativeData: operativeData
        )
    }
}
