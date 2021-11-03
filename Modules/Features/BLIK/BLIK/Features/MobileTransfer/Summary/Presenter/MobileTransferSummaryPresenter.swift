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
        getTransaction()
    }
    
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
    
    func goToBlikCode() {
        coordinator.goToBlikCode()
    }
}

private extension MobileTransferSummaryPresenter {
    func getTransaction() {
        Scenario(useCase: getTransactionUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                let viewModel = strongSelf.prepareViewModel(result)
                strongSelf.view?.setupStandardHeader(with: viewModel.header)
                strongSelf.view?.setupStandardBody(withItems: viewModel.bodyItems,
                                                   actions: viewModel.bodyActionItems,
                                                   collapsableSections: .defaultCollapsable(visibleSections: 3))
                strongSelf.view?.setupStandardFooterWithTitle(localized("footerSummary_label_andNow"), items: viewModel.footerItems)
                strongSelf.view?.build()
            }
            .onError { [weak self] error in
                self?.coordinator.goToBlikCode()
            }
    }
    
    func prepareViewModel(_ viewModel: MobileTransferSummaryViewModel) -> OperativeSummaryStandardViewModel {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_blik_text_success"),
                                                                      description: localized("pl_blik_text_successExpl"))
        
        var bodyItems: [OperativeSummaryStandardBodyItemViewModel] = [
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
        
        switch viewModel {
        case .trustedDevice(let info):
            bodyItems.append(.init(title: localized("pl_blik_text_withoutCode"), subTitle: info.label))
        default:
            break
        }
        
        var actions: [OperativeSummaryStandardBodyActionViewModel] = [
            .init(
                image: "icnShareBostonRedLight",
                title: "pl_topup_button_shareConfirm",
                action: { [weak self] in
                    self?.coordinator.shareSummary()
                }
            )
        ]
        
        switch viewModel {
        case .untrustedDevice(let info):
            actions.append(
                .init(
                    image: "icnShareBostonRedLight",
                    title: info.type == MobileTransferSummaryViewModel.UntrustedDeviceInfo.DeviceType.cookie.rawValue
                        ? "#Dodaj przeglądarkę do zaufanych"
                        : "#Dodaj sklep do zaufanych",
                    action: { [weak self] in
                        self?.coordinator.setDeviceAsTrusted()
                    }
                )
            )
        default:
            break
        }
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero", title: localized("pl_blik_summAnothTransf"), action: { [weak self] in
                self?.coordinator.goToMakeAnotherPayment()
            }),
            .init(imageKey: "icnPg", title: localized("generic_button_globalPosition"), action: { [weak self] in
                self?.goToGlobalPosition()
            }),
            .init(imageKey: "icnHelpUsMenu", title: localized("generic_button_improve"), action: { [weak self] in
                // TODO: For now this action goes to transfer main screen. In task TAP-1655 this should be change
                self?.coordinator.goToMakeAnotherPayment()
            })
        ]
        return OperativeSummaryStandardViewModel(header: headerViewModel,
                                                 bodyItems: bodyItems,
                                                 bodyActionItems: actions,
                                                 footerItems: footerItems)
        
    }
}
