import Operative
import Commons
import CoreFoundationLib
import UI

protocol CreditCardRepaymentSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {}

extension CreditCardRepaymentSummaryPresenterProtocol {
    var shouldShowProgressBar: Bool {
        false
    }
    
    var isBackable: Bool {
        false
    }
}

final class CreditCardRepaymentSummaryPresenter {
    weak var view: OperativeSummaryViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    
    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isCancelButtonEnabled: Bool = false
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
}

extension CreditCardRepaymentSummaryPresenter: CreditCardRepaymentSummaryPresenterProtocol {
    
    func viewDidLoad() {
        let viewModel = prepareViewModel()
            
        self.view?.setupStandardHeader(with: viewModel.header)
        self.view?.setupStandardBody(
            withItems: viewModel.bodyItems,
            actions: viewModel.bodyActionItems,
            collapsableSections: .defaultCollapsable(visibleSections: 4)
        )
        self.view?.setupStandardFooterWithTitle(
            localized("footerSummary_label_andNow"),
            items: viewModel.footerItems
        )
        self.view?.build()
    }
    
    private func prepareViewModel() -> OperativeSummaryStandardViewModel {
        let attributes = [NSAttributedString.Key.font: UIFont.santander(family: .headline, type: .bold, size: 14.0)]
        return OperativeSummaryStandardViewModelBuilder()
            .setHeader(
                image: "icnCheckOval1",
                title: localized("pl_creditCard_text_repSuccessText"),
                description: localized("pl_creditCard_text_repSuccessExpl"),
                extraInfo: nil
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_repAmount"),
                amount: formManager.summary?.amount
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_repSourceAccount"),
                accountAmount: formManager.summary?.account.availableAmount,
                accountAlias: formManager.summary?.account.alias
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_repType"),
                value: formManager.summary?.transferType,
                valueAttributes: attributes
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_cardRep"),
                value: formManager.summary?.creditCard.alias,
                valueAttributes: attributes
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_repSourceAccountNumb"),
                value: formManager.summary?.account.getDetailUI,
                valueAttributes: attributes
            )
            .addBodyItem(
                title: localized("pl_creditCard_label_repDate"),
                value: formManager.summary?.date.toString(format: "dd MMM YYYY"),
                valueAttributes: attributes
            )
            .addFooterItem(
                imageKey: "icnEnviarDinero",
                title: localized("generic_button_anotherPayment"),
                action: { [weak self] in
                    guard let self = self else { return }
                    self.container?.save(CreditCardRepaymentOperative.FinishingOption.makeAnotherPayment)
                    self.container?.stepFinished(presenter: self)
                }
            )
            .addFooterItem(
                imageKey: "icnHome",
                title: localized("generic_button_globalPosition"),
                action: { [weak self] in
                    guard let self = self else { return }
                    self.container?.save(CreditCardRepaymentOperative.FinishingOption.globalPosition)
                    self.container?.stepFinished(presenter: self)
                }
            )
            .addFooterItem(
                imageKey: "icnHelpUsMenu",
                title: localized("generic_button_improve"),
                action: { [weak self] in
                    guard let opinatorCapable = self?.container?.operative as? OperativeOpinatorCapable & Operative else { return }
                    opinatorCapable.showOpinator()
                }
            )
            .build()
    }
}
