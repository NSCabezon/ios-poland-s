import UI
import CoreFoundationLib
import PLUI
import SANLegacyLibrary
import PLCommons

protocol SplitPaymentFormViewDelegate: AnyObject {

}

final class SplitPaymentFormView: UIView {
    
    weak var delegate: SplitPaymentFormViewDelegate?
  
}
