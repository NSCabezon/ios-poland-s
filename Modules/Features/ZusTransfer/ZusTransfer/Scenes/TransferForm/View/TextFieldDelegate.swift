import UIKit

final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var textFieldDidBeginEditing: (() -> Void)?
    var textFieldDidEndEditing: (() -> Void)?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditing?()
    }
}
