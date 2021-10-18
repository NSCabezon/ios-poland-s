import TransferOperatives
import Models

final class SendMoneyModifier: SendMoneyModifierProtocol {
    var selectionDateOneFilterViewModel: SelectionDateOneFilterViewModel? {
        let labelViewModel = OneLabelViewModel(type: .normal, mainTextKey: "transfer_label_periodicity")
        let viewModel = SelectionDateOneFilterViewModel(oneLabelViewModel: labelViewModel, options: ["sendMoney_tab_today", "sendMoney_tab_chooseDay"])
        return viewModel
    }
    var freqOneInputSelectViewModel: OneInputSelectViewModel? {
        return OneInputSelectViewModel(status: .activated, infoLabelText: "sendMoney_label_periodicity", pickerData: ["periodicContribution_label_monthly", "periodicContribution_label_quarterly", "periodicContribution_label_biannual"], selectedInput: 0)
    }
    var bussinessOneInputSelectViewModel: OneInputSelectViewModel? {
        return OneInputSelectViewModel(status: .activated, pickerData: ["sendMoney_label_previousWorkingDay", "sendMoney_label_previousWorkingDay"], selectedInput: 0)
    }
    var isDescriptionRequired: Bool {
        return true
    }
}
