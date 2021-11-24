//
//  ChequeListCoordinator.swift
//  Account
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import UI
import Models
import Commons
import PLUI

public protocol ChequesCoordinatorProtocol: ModuleCoordinator {
    func pop()
    func showChequeDetails(_ cheque: BlikCheque)
    func showChequeCreationFlow(maxChequeAmount: Decimal)
    func showChequePIN(didSetPin: @escaping (() -> Void))
    func showShareSheet(cheque: BlikCheque)
    func showRemoveChequeConfirmationAlert(action: @escaping () -> Void)
}

public final class ChequesCoordinator {
    private let chequesFactory: ChequesProducing
    private let chequesPinFactory: ChequesPinProducing
    private let chequeFormFactory: ChequeFormProducing
    private let chequesDetailsFactory: ChequesDetailsProducing
    private let shareSheetFactory: ShareSheetProducing
    private let confirmationDialogFactory: ConfirmationDialogProducing
    
    public weak var navigationController: UINavigationController?
    private let shouldCofigurePin: Bool

    public init(
        navigationController: UINavigationController?,
        shouldCofigurePin: Bool,
        chequesFactory: ChequesProducing,
        chequesPinFactory: ChequesPinProducing,
        chequeFormFactory: ChequeFormProducing,
        chequesDetailsFactory: ChequesDetailsProducing,
        shareSheetFactory: ShareSheetProducing = ShareSheetFactory(),
        confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    ) {
        self.navigationController = navigationController
        self.shouldCofigurePin = shouldCofigurePin
        self.chequesFactory = chequesFactory
        self.chequesPinFactory = chequesPinFactory
        self.chequeFormFactory = chequeFormFactory
        self.chequesDetailsFactory = chequesDetailsFactory
        self.shareSheetFactory = shareSheetFactory
        self.confirmationDialogFactory = confirmationDialogFactory
    }
    
    public func start() {
        let controller = chequesFactory.create(coordinator: self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChequesCoordinator: ChequesCoordinatorProtocol {
    public func showChequeDetails(_ cheque: BlikCheque) {
        let controller = chequesDetailsFactory.create(coordinator: self, cheque: cheque)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    public func showChequeCreationFlow(maxChequeAmount: Decimal) {
        if shouldCofigurePin {
            showChequePIN(didSetPin: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showSetPinSuccessAlert()
                strongSelf.navigationController?.popViewController(animated: false)
                strongSelf.showChequeCreationForm(maxChequeAmount: maxChequeAmount)
            })
        } else {
            showChequeCreationForm(maxChequeAmount: maxChequeAmount)
        }
    }
    
    public func showChequePIN(didSetPin: @escaping () -> Void) {
        let controller = chequesPinFactory.create(
            coordinator: self,
            didSetPin: { [weak self] in
                self?.showSetPinSuccessAlert()
                didSetPin()
            }
        )
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    public func showShareSheet(cheque: BlikCheque) {
        let text = localized("pl_blik_text_cheque_message", [StringPlaceholder(.value, "\(cheque.ticketCode)")])
        let controller = shareSheetFactory.create(type: .text(text.text))
        navigationController?.present(controller, animated: true)
    }
    
    public func showRemoveChequeConfirmationAlert(action: @escaping () -> Void) {
        guard let navigationController = navigationController else { return }
        let dialog = confirmationDialogFactory.create(
            message: localized("pl_blik_alert_deleteConfirm"),
            confirmAction: action,
            declineAction: {}
        )
        dialog.showIn(navigationController)
    }
    
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showSetPinSuccessAlert() {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_passSuccess"),
            alertType: .info,
            position: .top
        )
    }
    
    private func showChequeCreationForm(maxChequeAmount: Decimal) {
        let controller = chequeFormFactory.create(
            coordinator: self,
            maxChequeAmount: maxChequeAmount
        )
        navigationController?.pushViewController(controller, animated: true)
    }
}
