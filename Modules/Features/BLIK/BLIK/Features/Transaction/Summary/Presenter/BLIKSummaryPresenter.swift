import Models
import Commons
import Operative
import UI
import PLCommons

protocol BLIKSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func goToGlobalPosition()
}

final class BLIKSummaryPresenter {
    weak var view: OperativeSummaryViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let viewModel: BLIKTransactionViewModel

    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isBackable: Bool = false
    var isCancelButtonEnabled: Bool = true
    
    init(dependenciesResolver: DependenciesResolver, viewModel: BLIKTransactionViewModel) {
        self.dependenciesResolver = dependenciesResolver
        self.viewModel = viewModel
    }
}

private extension BLIKSummaryPresenter {
    var coordinator: BLIKSummaryCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: BLIKSummaryCoordinatorProtocol.self)
    }
}

extension BLIKSummaryPresenter: BLIKSummaryPresenterProtocol {
    func viewDidLoad() {
        
        let viewModel = prepareViewModel()
     
        view?.setupStandardHeader(with: viewModel.header)
        view?.setupStandardBody(withItems: viewModel.bodyItems,
                                actions: viewModel.bodyActionItems,
                                collapsableSections: .defaultCollapsable(visibleSections: 3))
        view?.setupStandardFooterWithTitle(localized("footerSummary_label_andNow"), items: viewModel.footerItems)
        
        view?.build()
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
}

private extension BLIKSummaryPresenter {
    
    func prepareViewModel() -> OperativeSummaryStandardViewModel {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_blik_text_success"),
                                                                      description: localized("pl_blik_text_successExpl"))
        
        var bodyItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: viewModel.amountString(withAmountSize: 32),
                  info: viewModel.title,
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.itemAmount.id),
            .init(title: localized("pl_blik_label_transType"),
                  subTitle: viewModel.transferTypeString,
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.itemTransferType.id),
        ]
        
        if let address = viewModel.address {
            bodyItems.append(
                .init(title: localized("pl_blik_label_place"),
                      subTitle: address,
                      accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.itemAddress.id)
            )
        }
        
        bodyItems.append(.init(title: localized("pl_blik_label_date"),
                               subTitle: viewModel.dateString,
                               accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.itemDate.id))
        
        let action: OperativeSummaryStandardBodyActionViewModel = .init(
            image: "logout",
            title: localized("pl_blik_text_summLogOut"),
            titleAccessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.actionLogout.id,
            action: {
                let sessionManager = self.dependenciesResolver.resolve(for: CoreSessionManager.self)
                sessionManager.finishWithReason(.logOut)
            }
        )
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero",
                  title: localized("pl_blik_summAnothCode"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerAnotherCode.id,
                  action: { [weak self] in
                    self?.coordinator.goToMakeAnotherPayment()
                  }),
            .init(imageKey: "icnPg",
                  title: localized("generic_button_globalPosition"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerGlobalPosition.id,
                  action: { [weak self] in
                    self?.coordinator.goToGlobalPosition()
                  }),
            .init(imageKey: "icnHelpUsMenu",
                  title: localized("generic_button_improve"),
                  accessibilityIdentifier: AccessibilityBLIK.SummaryOperativeSummary.footerImprove.id,
                  action: { [weak self] in
                    // TODO: For now this action goes to BLIK main screen. In task TAP-1655 this should be change
                    self?.coordinator.goToMakeAnotherPayment()
                  })
        ]
        return OperativeSummaryStandardViewModel(header: headerViewModel,
                                                 bodyItems: bodyItems,
                                                 bodyActionItems: [action],
                                                 footerItems: footerItems)
        
    }
}
