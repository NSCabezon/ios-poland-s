//
//  SendMoneyTransferTypePresenter.swift
//  TransferOperatives
//
//  Created by José Norberto Hidalgo on 29/9/21.
//

import Operative
import CoreFoundationLib
import Commons
import TransferOperatives
import CoreDomain
import SANLegacyLibrary

protocol SendMoneyTransferTypePresenterProtocol: OperativeStepPresenterProtocol {
    var view: SendMoneyTransferTypeView? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectClose()
    func didSelectTransferType(at index: Int)
    func didPressedFloatingButton()
    func didTapCloseAmountHigh()
    func didTapTooltip()
    func getSubtitleInfo() -> String
}

final class SendMoneyTransferTypePresenter {
    var number: Int = 0
    var isBackButtonEnabled: Bool = true
    var isCancelButtonEnabled: Bool = true
    var container: OperativeContainerProtocol?
    weak var view: SendMoneyTransferTypeView?
    private lazy var operativeData: SendMoneyOperativeData = {
        guard let container = self.container else { fatalError() }
        return container.get()
    }()
    private lazy var transferTypes: [SendMoneyTransferTypeFee]? = {
        guard let specialPricesOutput = self.operativeData.specialPricesOutput as? SendMoneyTransferTypeUseCaseOkOutput
        else { return nil }
        return specialPricesOutput.fees
    }()
    private lazy var isCreditCardAccount: Bool? = {
        guard let specialPricesOutput = self.operativeData.specialPricesOutput as? SendMoneyTransferTypeUseCaseOkOutput
        else { return nil }
        return specialPricesOutput.isCreditCardAccount
    }()
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension SendMoneyTransferTypePresenter: SendMoneyTransferTypePresenterProtocol {
    func viewDidLoad() {
        let viewModel = self.mapToSendMoneyTransferTypeRadioButtonsContainerViewModel(from: self.transferTypes ?? [])
        self.view?.showTransferTypes(viewModel: viewModel)
        self.setCreditAccountInfo()
    }
    
    func setCreditAccountInfo() {
        if isCreditCardAccount == true {
            self.view?.setBottomInformationTextKey("pl_sendType_disclaimer_commissionsPercentage")
        } else {
            self.view?.setBottomInformationTextKey("sendType_disclaimer_commissions")
        }
    }
    
    func didSelectBack() {
        self.container?.back()
    }
    
    func didSelectClose() {
        self.container?.close()
    }
    
    func didSelectTransferType(at index: Int) {
        self.operativeData.selectedTransferType = self.transferTypes?[index]
    }
    
    func didPressedFloatingButton() {
        guard let amount = self.operativeData.amount?.value,
              let transferType = self.operativeData.selectedTransferType?.type as? PolandTransferType,
              let limitAmount = transferType.limitAmount.value
        else { return }
        if limitAmount.isZero || amount.isLessThanOrEqualTo(limitAmount) {
            self.container?.stepFinished(presenter: self)
        } else {
            self.view?.showAmountTooHighView()
        }
    }
    
    func didTapCloseAmountHigh() {
        self.view?.closeAmountTooHighView()
    }
    
    func getSubtitleInfo() -> String {
        self.container?.getSubtitleInfo(presenter: self) ?? ""
    }
    
    func didTapTooltip() {
        self.trackerManager.trackEvent(screenId: self.trackerPage.page, eventId: SendMoneyTransferTypePage.Action.clickTooltip.rawValue, extraParameters: ["transfer_country": self.operativeData.type.trackerName])
    }
}

private extension SendMoneyTransferTypePresenter {
    func mapToSendMoneyTransferTypeRadioButtonsContainerViewModel(from transferTypes: [SendMoneyTransferTypeFee]) -> SendMoneyTransferTypeRadioButtonsContainerViewModel {
        let radioButtonViewModels = transferTypes.compactMap { self.mapToSendMoneyTransferTypeRadioButtonViewModel(from: $0) }
        return SendMoneyTransferTypeRadioButtonsContainerViewModel(selectedIndex: self.getSelectedIndex(),
                                                                   viewModels: radioButtonViewModels)
    }
    
    func mapToSendMoneyTransferTypeRadioButtonViewModel(from transferType: SendMoneyTransferTypeFee) -> SendMoneyTransferTypeRadioButtonViewModel? {
        guard let type = transferType.type as? PolandTransferType else { return nil }
        let oneRadioButtonViewModel = OneRadioButtonViewModel(status: .inactive,
                                                              titleKey: localized(type.title ?? ""),
                                                              subtitleKey: localized(type.subtitle ?? ""))
        let feeViewModel = SendMoneyTransferTypeFeeViewModel(amount: transferType.fee,
                                                             status: .inactive)
        return SendMoneyTransferTypeRadioButtonViewModel(oneRadioButtonViewModel: oneRadioButtonViewModel,
                                                         feeViewModel: feeViewModel)
    }

    func getAccessibilitySuffixForTransferType(_ transferType: PolandTransferType) -> String {
        switch transferType {
        case .one: return AccessibilitySendMoneyTransferType.RadioButtons.standardSuffix
        case .eight: return AccessibilitySendMoneyTransferType.RadioButtons.immediateSuffix
        case .a: return AccessibilitySendMoneyTransferType.RadioButtons.expressDeliverySuffix
        default: return "_unknown"
        }
    }

    func getSelectedIndex() -> Int {
        guard let selectedTransferTypeFee = self.operativeData.selectedTransferType,
              let selectedType = selectedTransferTypeFee.type as? PolandTransferType,
              let selectedFee = selectedTransferTypeFee.fee?.value
        else { return .zero }
        return transferTypes?.firstIndex(where: { transferTypeFee in
            guard let type = transferTypeFee.type as? PolandTransferType,
                  let fee = transferTypeFee.fee?.value else { return false }
            return type == selectedType && fee == selectedFee
        }) ?? .zero
    }
}

extension SendMoneyTransferTypePresenter: AutomaticScreenActionTrackable {
    var trackerPage: SendMoneyTransferTypePage {
        SendMoneyTransferTypePage()
    }
    
    var trackerManager: TrackerManager {
        dependenciesResolver.resolve(for: TrackerManager.self)
    }
}
