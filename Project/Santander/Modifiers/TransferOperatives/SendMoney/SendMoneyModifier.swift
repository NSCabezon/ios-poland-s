import TransferOperatives
import CoreFoundationLib
import Operative
import OpenCombine

final class SendMoneyModifier: SendMoneyModifierProtocol {
    private let legacyDependenciesResolver: DependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    
    var isEnabledChangeCountry: Bool = true
    
    init(legacyDependenciesResolver: DependenciesResolver) {
        self.legacyDependenciesResolver = legacyDependenciesResolver
        self.bindInternationalSendMoney()
    }
    
    var selectionDateOneFilterViewModel: SelectionDateOneFilterViewModel? {
        let labelViewModel = OneLabelViewModel(type: .normal, mainTextKey: "transfer_label_periodicity")
        let viewModel = SelectionDateOneFilterViewModel(oneLabelViewModel: labelViewModel, options: ["sendMoney_tab_today", "sendMoney_tab_chooseDay"])
        return viewModel
    }
    
    var freqOneInputSelectViewModel: OneInputSelectViewModel? {
        return OneInputSelectViewModel(status: .activated, pickerData: ["periodicContribution_label_monthly", "periodicContribution_label_quarterly", "periodicContribution_label_biannual"], selectedInput: 0)
    }
    
    var bussinessOneInputSelectViewModel: OneInputSelectViewModel? {
        return OneInputSelectViewModel(status: .activated, pickerData: ["sendMoney_label_previousWorkingDay", "sendMoney_label_previousWorkingDay"], selectedInput: 0)
    }
    
    var isDescriptionRequired: Bool {
        return true
    }
    
    var shouldShowSaveAsFavourite: Bool {
        return false
    }
    
    var transferTypeStep: OperativeStep? {
        return SendMoneyTransferTypeStep(legacyDependenciesResolver: legacyDependenciesResolver)
    }

    func getTransferTypeStep(dependencies: DependenciesInjector & DependenciesResolver) -> OperativeStep? {
        return SendMoneyTransferTypeStep(legacyDependenciesResolver: dependencies)
    }

    func goToSendMoney() {
        self.legacyDependenciesResolver.resolve(for: SendMoneyCoordinatorProtocol.self).start()
    }
    
    var doubleValidationRequired = false
    
    func transferTypeFor(onePayType: SendMoneyTransferType, subtype: String) -> String {
        return subtype
    }
    
    let confirmationNotifyEmail = false
    
    func addSendType(operativeData: SendMoneyOperativeData) -> String? {
        let isCreditCardAccount: Bool? = {
            guard let specialPricesOutput = operativeData.specialPricesOutput as? SendMoneyTransferTypeUseCaseOkOutput
            else { return nil }
            return specialPricesOutput.isCreditCardAccount
        }()
        if isCreditCardAccount == true {
            return "pl_confirmation_label_commissionsPercentage"
        } else {
            return nil
        }
    }
    
    var giveUpOpinator: String {
        return "app-transf-nacional-abandono"
    }
    
    var favoriteGiveUpOpinator: String {
        return "app-envio-favorito-abandono"
    }
    
    var selectionIssueDateViewModel: SelectionIssueDateViewModel {
        return SelectionIssueDateViewModel(minDate: Date(), maxDate: Date().adding(.year, value: 1))
    }
    
    var maxProgressBarSteps: Int {
        return 6
    }
    
    func isCurrencyEditable(_ operativeData: SendMoneyOperativeData) -> Bool {
        return isEnabledChangeCountry
    }
    
    func getAmountStep(operativeData: SendMoneyOperativeData, dependencies: DependenciesResolver) -> OperativeStep {
        if operativeData.type == .allInternational || operativeData.type == .noSepa {
            return SendMoneyAmountAllInternationalStep(legacyDependenciesResolver: dependencies)
        } else {
            return SendMoneyAmountStep(dependenciesResolver: dependencies)
        }
    }
}

private extension SendMoneyModifier {
    func bindInternationalSendMoney() {
        let booleanFeatureFlag: BooleanFeatureFlag = legacyDependenciesResolver.resolve()
        booleanFeatureFlag.fetch(CoreFeatureFlag.internationalSendMoney)
            .sink { [unowned self] result in
                self.isEnabledChangeCountry = result
            }
            .store(in: &subscriptions)
    }
}
