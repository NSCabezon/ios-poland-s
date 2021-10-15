import Foundation

protocol ChequePinValidating {
    func validate(pin: ChequePin) -> Result<Void, ChequePinError>
}

final class ChequePinValidator: ChequePinValidating {
    public func validate(pin: ChequePin) -> Result<Void, ChequePinError> {
        if pin.pin != pin.pinConfirmation {
            return .failure(.pinIsNotMatch)
        }
        
        return .success(Void())
    }
}
