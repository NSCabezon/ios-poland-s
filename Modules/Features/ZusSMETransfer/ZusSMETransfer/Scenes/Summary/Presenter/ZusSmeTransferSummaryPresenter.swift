import CoreFoundationLib
import PLCommons
import Operative
import UI

protocol ZusSmeTransferSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func close()
}

final class ZusSmeTransferSummaryPresenter {
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
    private let summary: ZusSmeSummaryModel
    
    init(dependenciesResolver: DependenciesResolver, summary: ZusSmeSummaryModel) {
        self.dependenciesResolver = dependenciesResolver
        self.summary = summary
    }
}

private extension ZusSmeTransferSummaryPresenter {
    var coordinator: ZusSmeTransferSummaryCoordinatorProtocol {
        return dependenciesResolver.resolve(for: ZusSmeTransferSummaryCoordinatorProtocol.self)
    }
}

extension ZusSmeTransferSummaryPresenter: ZusSmeTransferSummaryPresenterProtocol {
    func viewDidLoad() {
        prepareViewModel()
    }
    
    func close() {
        coordinator.goToGlobalPosition()
    }
}

private extension ZusSmeTransferSummaryPresenter {
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
                  info: makeAccountsInfoAttributedString()),
            .init(title: localized("pl_zusTransfer_text_receipent"),
                  subTitle: summary.recipientName,
                  info: summary.recipientAccountNumber),
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
                let opinator = RegularOpinatorInfoEntity(path: "APP-RET-zus-transfer-SUCCESS")
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
    
    func makeAccountsInfoAttributedString() -> NSMutableAttributedString {
        let attributedStringAccountNumber = AttributedStringBuilder(
            string: IBANFormatter.format(iban: summary.accountNumber),
            properties: attributedAccountNumber
        ).build()
        let attributedStringTitleVat = AttributedStringBuilder(
            string: ["\n",localized("pl_zusTransfer_text_linkedAccName")].joined(),
            properties: attributedTitleVat
        ).build()
        let accountVatName = summary.accountVat?.name ?? ""
        let attributedStringSubtitleVat = AttributedStringBuilder(
            string: ["\n", accountVatName].joined(),
            properties: attributedSubtitleVat
        ).build()
        let attributedStringAccountVatNumber = AttributedStringBuilder(
            string: ["\n",IBANFormatter.format(iban: summary.accountVat?.number)].joined(),
            properties: attributedAccountVatNumber
        ).build()

        let attributedAccountDetails = NSMutableAttributedString()
        [
            attributedStringAccountNumber,
            attributedStringTitleVat,
            attributedStringSubtitleVat,
            attributedStringAccountVatNumber
        ].forEach {
            attributedAccountDetails.append($0)
        }
        return attributedAccountDetails
    }
}

private extension ZusSmeTransferSummaryPresenter {
    
    var attributedAccountNumber: [NSAttributedString.Key: NSObject] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        return [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .italic, size: 14),
            NSAttributedString.Key.paragraphStyle: style
        ]
    }
    
    var attributedTitleVat: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.grafite,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .regular, size: 13)
        ]
    }
    
    var attributedSubtitleVat: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .bold, size: 14)
        ]
    }
    
    var attributedAccountVatNumber: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .italic, size: 14)
        ]
    }
}

