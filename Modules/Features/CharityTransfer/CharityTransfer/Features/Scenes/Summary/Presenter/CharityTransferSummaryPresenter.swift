import CoreFoundationLib
import PLCommons
import Operative
import CoreFoundationLib

protocol CharityTransferSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func goToCharityTransfer()
    func goToGlobalPosition()
}

final class CharityTransferSummaryPresenter {
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
    
    private let dependenciesResolver: DependenciesResolver
    private let summary: CharityTransferSummary
    
    init(dependenciesResolver: DependenciesResolver, summary: CharityTransferSummary) {
        self.dependenciesResolver = dependenciesResolver
        self.summary = summary
    }
}

private extension CharityTransferSummaryPresenter {
    var coordinator: CharityTransferSummaryCoordinatorProtocol {
        return dependenciesResolver.resolve(for: CharityTransferSummaryCoordinatorProtocol.self)
    }
}

extension CharityTransferSummaryPresenter: CharityTransferSummaryPresenterProtocol {
    func viewDidLoad() {
        prepareViewModel()
    }
    
    func goToCharityTransfer() {
        coordinator.goToMakeAnotherPayment()
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
}

private extension CharityTransferSummaryPresenter {
    func prepareViewModel() {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_foundtrans_text_success"),
                                                                      description: localized("pl_foundtrans_text_successExpl"))
        
        let bodyItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: PLAmountFormatter.amountString(amount: summary.amount, currency: summary.currency, withAmountSize: 32),
                  info: summary.title), 
            .init(title: localized("pl_foundtrans_label_summ_accountNumb"),
                  subTitle: summary.accountName,
                  info: summary.accountNumber),
            .init(title: localized("pl_foundtrans_label_recipientTransfer"),
                  subTitle: summary.recipientName),
            .init(title: localized("pl_foundtrans_label_transType"),
                  subTitle: localized("pl_foundtrans_label_internalTransfer")),
            .init(title: localized("pl_foundtrans_label_date"),
                  subTitle: summary.dateString)
        ]
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero", title: localized("generic_button_anotherPayment"), action: { [weak self] in
                self?.coordinator.goToMakeAnotherPayment()
            }),
            .init(imageKey: "icnPg", title: localized("generic_button_globalPosition"), action: { [weak self] in
                self?.coordinator.goToGlobalPosition()
            }),
            .init(imageKey: "icnHelpUsMenu", title: localized("generic_button_improve"), action: { [weak self] in
                let opinator = RegularOpinatorInfoEntity(path: "APP-RET-charity-payment-SUCCESS")
                let coordinator = self?.dependenciesResolver.resolve(for: OperativeContainerCoordinatorDelegate.self)
                coordinator?.handleOpinator(opinator)
            })
        ]
        let viewModel = OperativeSummaryStandardViewModel(header: headerViewModel,
                                                          bodyItems: bodyItems,
                                                          bodyActionItems: [],
                                                          footerItems: footerItems)
        
        view?.setupStandardHeader(with: viewModel.header)
        view?.setupStandardBody(withItems: viewModel.bodyItems,
                                actions: viewModel.bodyActionItems,
                                collapsableSections: .defaultCollapsable(visibleSections: 3))
        view?.setupStandardFooterWithTitle(localized("footerSummary_label_andNow"), items: viewModel.footerItems)
        view?.build()
    }
}
