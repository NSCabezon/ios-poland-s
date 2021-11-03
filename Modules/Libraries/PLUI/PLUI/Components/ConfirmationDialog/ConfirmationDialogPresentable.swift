import Foundation
import UI

public protocol ConfirmationDialogPresentable {
    func showDialog(_ dialog: LisboaDialog)
}

public extension ConfirmationDialogPresentable where Self: UIViewController {
    func showDialog(_ dialog: LisboaDialog) {
        dialog.showIn(self)
    }
}
