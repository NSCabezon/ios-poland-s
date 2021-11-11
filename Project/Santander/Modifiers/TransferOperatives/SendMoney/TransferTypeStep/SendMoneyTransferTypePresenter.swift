//
//  SendMoneyTransferTypePresenter.swift
//  TransferOperatives
//
//  Created by José Norberto Hidalgo on 29/9/21.
//

import Operative
import Models
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
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension SendMoneyTransferTypePresenter: SendMoneyTransferTypePresenterProtocol {
    func viewDidLoad() {
        let viewModel = self.mapToSendMoneyTransferTypeRadioButtonsContainerViewModel(from: self.transferTypes ?? [])
        self.view?.showTransferTypes(viewModel: viewModel)
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
                                                              titleKey: localized(type.title ?? "") ?? "",
                                                              subtitleKey: localized(type.subtitle ?? ""))
        let feeViewModel = SendMoneyTransferTypeFeeViewModel(amount: transferType.fee,
                                                             status: .inactive)
        return SendMoneyTransferTypeRadioButtonViewModel(oneRadioButtonViewModel: oneRadioButtonViewModel,
                                                         feeViewModel: feeViewModel)
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

extension PolandTransferType {
    var title: String? {
        switch self {
        case .zero, .one:
            return "sendMoney_label_standardSent"
        case .eight:
            return "sendMoney_label_immediateSend"
        case .a:
            return "sendMoney_label_expressDelivery"
        case .creditCardAccount:
            return "sendMoney_title_creditCardAccount"
        case .four:
            return nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .zero, .one:
            return "sendType_text_standar"
        case .eight:
            return "sendType_text_inmediate"
        case .a:
            return "sendType_text_express"
        case .creditCardAccount:
            return "sendMoney_text_creditCardAccount"
        case .four:
            return nil
        }
    }
    
    var limitAmount: AmountRepresentable {
        switch self {
        case .eight:
            return AmountDTO(value: Decimal(5000), currency: .create(.złoty))
        case .a:
            return AmountDTO(value: Decimal(20000), currency: .create(.złoty))
        case .creditCardAccount, .zero, .one, .four:
            return AmountDTO(value: .zero, currency: .create(.złoty))
        }
    }
}
