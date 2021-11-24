import Models
import Commons
import Operative
import DomainCommon

protocol MobileTransferSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func goToGlobalPosition()
    func goToBlikCode()
}

final class MobileTransferSummaryPresenter {
    weak var view: OperativeSummaryViewProtocol?
    
    //These variables below are forced to be conformed to OperativeStepPresenterProtocol, we need to have it to display summary screen from core
    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isBackable: Bool = false
    var isCancelButtonEnabled: Bool = true
    
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    private var getTransactionUseCase: GetTransactionUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private let dependenciesResolver: DependenciesResolver
    private let summary: MobileTransferSummary
    
    init(dependenciesResolver: DependenciesResolver, summary: MobileTransferSummary) {
        self.dependenciesResolver = dependenciesResolver
        self.summary = summary
    }
}

private extension MobileTransferSummaryPresenter {
    var coordinator: MobileTransferSummaryCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: MobileTransferSummaryCoordinatorProtocol.self)
    }
}

extension MobileTransferSummaryPresenter: MobileTransferSummaryPresenterProtocol {
    func viewDidLoad() {
        prepareViewModel()
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
    
    func goToBlikCode() {
        coordinator.goToBlikCode()
    }
}

private extension MobileTransferSummaryPresenter {
    func prepareViewModel() {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_blik_text_success"),
                                                                      description: localized("pl_blik_text_successExpl"))
        let bodyItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: AmountFormatter.amountString(amount: summary.amount, currency: summary.currency, withAmountSize: 32),
                  info: localized("pl_blik_label_transferTypeSumm")),
            .init(title: localized("pl_blik_label_accountTransfter"),
                  subTitle: summary.accountName,
                  info: summary.accountNumber),
            .init(title: localized("pl_blik_label_recipientTransfer"),
                  subTitle: summary.recipientName,
                  info: summary.recipientNumber),
            .init(title: localized("pl_blik_label_transType"),
                  subTitle: localized("pl_blik_label_transferTypeSumm")),
            .init(title: localized("confirmation_item_date"),
                  subTitle: summary.dateString)
        ]
        
        let actions: [OperativeSummaryStandardBodyActionViewModel] = [
            .init(
                image: "icnShareBostonRedLight",
                title: "pl_topup_button_shareConfirm",
                action: { [weak self] in
                    self?.coordinator.shareSummary()
                }
            )
        ]
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero", title: localized("pl_blik_summAnothTransf"), action: { [weak self] in
                self?.coordinator.goToMakeAnotherPayment()
            }),
            .init(imageKey: "icnPg", title: localized("generic_button_globalPosition"), action: { [weak self] in
                self?.goToGlobalPosition()
            }),
            .init(imageKey: "icnHelpUsMenu", title: localized("generic_button_improve"), action: { [weak self] in
                let opinator = RegularOpinatorInfoEntity(path: "/APP-RET-blik-transfer-SUCCESS")
                let coordinator = self?.dependenciesResolver.resolve(for: OperativeContainerCoordinatorDelegate.self)
                coordinator?.handleOpinator(opinator)
            })
        ]
        let viewModel = OperativeSummaryStandardViewModel(header: headerViewModel,
                                                          bodyItems: bodyItems,
                                                          bodyActionItems: actions,
                                                          footerItems: footerItems)
        
        
        view?.setupStandardHeader(with: viewModel.header)
        view?.setupStandardBody(withItems: viewModel.bodyItems,
                                actions: viewModel.bodyActionItems,
                                collapsableSections: .defaultCollapsable(visibleSections: 3))
        view?.setupStandardFooterWithTitle(localized("footerSummary_label_andNow"), items: viewModel.footerItems)
        view?.build()
    }
}
