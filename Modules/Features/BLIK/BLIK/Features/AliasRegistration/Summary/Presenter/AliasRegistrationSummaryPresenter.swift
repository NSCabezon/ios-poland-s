import CoreFoundationLib
import Operative
import UI
import PLCommons
import PLUI

protocol AliasRegistrationSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func goToGlobalPosition()
}

final class AliasRegistrationSummaryPresenter {
    weak var view: OperativeSummaryViewProtocol?
    private let dependenciesResolver: DependenciesResolver

    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isBackable: Bool = false
    var isCancelButtonEnabled: Bool = true
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension AliasRegistrationSummaryPresenter {
    var coordinator: AliasRegistrationSummaryCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: AliasRegistrationSummaryCoordinatorProtocol.self)
    }
}

extension AliasRegistrationSummaryPresenter: AliasRegistrationSummaryPresenterProtocol {
    func viewDidLoad() {
        view?.setupStandardHeader(with: getHeaderViewModel())
        view?.setupStandardFooterWithTitle(
            localized("footerSummary_label_andNow"),
            items: getFooterItems()
        )
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
}

private extension AliasRegistrationSummaryPresenter {
    func getHeaderViewModel() -> OperativeSummaryStandardHeaderViewModel {
        return OperativeSummaryStandardHeaderViewModel(
            image: "icnCheckOval1",
            title: localized("pl_blik_text_success"),
            description: localized("pl_blik_text_successExpl")
        )
    }
    
    func getFooterItems() -> [OperativeSummaryStandardFooterItemViewModel] {
        return [
            OperativeSummaryStandardFooterItemViewModel(imageKey: "icnEnviarDinero",
                  title: localized("pl_blik_summAnothCode"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerAnotherCode.id,
                  action: { [weak self] in
                    self?.coordinator.goToMakeAnotherPayment()
                  }),
            OperativeSummaryStandardFooterItemViewModel(imageKey: "icnPg",
                  title: localized("generic_button_globalPosition"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerGlobalPosition.id,
                  action: { [weak self] in
                    self?.coordinator.goToGlobalPosition()
                  }),
            OperativeSummaryStandardFooterItemViewModel(imageKey: "icnHelpUsMenu",
                  title: localized("generic_button_improve"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerImprove.id,
                  action: { [weak self] in
                    self?.coordinator.goToMakeAnotherPayment()
                  })
        ]
    }
}
