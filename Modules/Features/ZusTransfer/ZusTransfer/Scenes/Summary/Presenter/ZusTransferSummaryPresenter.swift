import CoreFoundationLib
import PLCommons
import Operative

protocol ZusTransferSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func goToZusTransfer()
}

final class ZusTransferSummaryPresenter {
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
    private let summary: ZusTransferSummary
    
    init(dependenciesResolver: DependenciesResolver, summary: ZusTransferSummary) {
        self.dependenciesResolver = dependenciesResolver
        self.summary = summary
    }
}

private extension ZusTransferSummaryPresenter {
    var coordinator: ZusTransferSummaryCoordinatorProtocol {
        return dependenciesResolver.resolve(for: ZusTransferSummaryCoordinatorProtocol.self)
    }
}

extension ZusTransferSummaryPresenter: ZusTransferSummaryPresenterProtocol {
    func viewDidLoad() {
        prepareViewModel()
    }
    
    func goToZusTransfer() {
        coordinator.goToMakeAnotherPayment()
    }
}

private extension ZusTransferSummaryPresenter {
    func prepareViewModel() {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_zus_text_success"),
                                                                      description: localized("pl_zus_text_successExpl"))
        
        let bodyItems: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("pl_zusTransfer_text_Amount"),
                  subTitle: PLAmountFormatter.amountString(amount: summary.amount, currency: summary.currency, withAmountSize: 32),
                  info: summary.title), 
            .init(title: localized("pl_zusTransfer_text_account"),
                  subTitle: summary.accountName,
                  info: summary.accountNumber),
            .init(title: localized("pl_zusTransfer_text_receipent"),
                  subTitle: summary.recipientName),
            .init(title: localized("pl_zusTransfer_text_transactionType"),
                  subTitle: localized("pl_zusTransfer_text_transactionTypeText")),
            .init(title: localized("pl_zusTransfer_text_date"),
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
                #warning("Need to add opinator link")
                let opinator = RegularOpinatorInfoEntity(path: "")
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
