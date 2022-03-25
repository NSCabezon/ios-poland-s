import TransferOperatives
import CoreFoundationLib
import Operative

final class SendMoneyModifier: SendMoneyModifierProtocol {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
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
    let shouldShowSaveAsFavourite: Bool = false
    
    func getTransferTypeStep(dependencies: DependenciesInjector & DependenciesResolver) -> OperativeStep? {
        return SendMoneyTransferTypeStep(dependencies: dependencies)
    }
    
    func goToSendMoney() {
        self.dependenciesEngine.resolve(for: SendMoneyCoordinatorProtocol.self).start()
    }
    
    var doubleValidationRequired = false
    
    func transferTypeFor(onePayType: OnePayTransferType, subtype: String) -> String {
        return subtype
    }
    
    var isEditConfirmationEnabled: Bool = false
    
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
}
