import UIKit

protocol SnackbarPresentable {}

extension SnackbarPresentable {
    func showSnackbar(message: String, type: Snackbar.SnackbarType) {
        let snackbar = Snackbar()
        snackbar.attachToMainWindow()

        snackbar.showMessage(
            message,
            type: type,
            completion: { snackbar.removeFromSuperview() }
        )
    }
}

private extension UIView {
    func attachToMainWindow() {
        let window = UIApplication.shared.keyWindow!
        translatesAutoresizingMaskIntoConstraints = false
        
        window.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: window.topAnchor),
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
    }
}
