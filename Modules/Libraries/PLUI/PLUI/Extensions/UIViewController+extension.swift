import UI

extension UIViewController {
    public func configureKeyboardDismissGesture(shouldCancelTouchesInView: Bool = true) {
        let dismissGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        dismissGesture.cancelsTouchesInView = shouldCancelTouchesInView
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc fileprivate func hideKeyboard() {
        view.endEditing(true)
    }
}
