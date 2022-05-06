import UI

extension UIViewController {
    public func configureKeyboardDismissGesture() {
        let dismissGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc fileprivate func hideKeyboard() {
        view.endEditing(true)
    }
}
