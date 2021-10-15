import Foundation
import Operative
import Commons

final class CreditCardChooseListStep: OperativeStep {
    
    let dependenciesResolver: DependenciesResolver
    weak var view: OperativeView? {
        self.dependenciesResolver.resolve(for: CreditCardChooseListViewProtocol.self)
    }
    var presentationType: OperativeStepPresentationType {
        .inNavigation(showsBack: true, showsCancel: true)
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}
