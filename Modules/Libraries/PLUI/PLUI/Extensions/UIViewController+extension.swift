import UI

extension UIViewController {
    public func configureKeyboardDismissGesture() {
        let dismissGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        dismissGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc fileprivate func hideKeyboard() {
        view.endEditing(true)
    }
}
