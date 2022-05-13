//
//  SMAmountAllInternationalSwiftView.swift
//  TransferOperatives
//
//  Created by José María Jiménez Pérez on 26/4/22.
//

import UIOneComponents
import UI
import CoreFoundationLib
import UIKit

protocol SMAmountAllInternationalSwiftViewDelegate: AnyObject {
    func saveSwift(_ swift: String?)
}

final class SMAmountAllInternationalSwiftView: UIView {
    
    private var view: UIView?
    
    @IBOutlet private weak var swiftTitle: UILabel!
    @IBOutlet private weak var oneLabelSwiftTitle: OneLabelView!
    @IBOutlet private weak var oneInpuntSwiftValue: OneInputRegularView!
    
    weak var delegate: SMAmountAllInternationalSwiftViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupAccessibilityIds()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.setupAccessibilityIds()
    }
    
    func setSwiftText(_ text: String?) {
        self.oneInpuntSwiftValue.setInputText(text)
    }
}

private extension SMAmountAllInternationalSwiftView {
    func setupViews() {
        self.xibSetup()
        self.swiftTitle.textFont = .typography(fontName: .oneH100Bold)
        self.swiftTitle.textColor = .oneLisboaGray
        self.swiftTitle.configureText(withKey: "sendMoney_label_recipientBank")
        self.oneLabelSwiftTitle.setupViewModel(
            OneLabelViewModel(type: .helper,
                              mainTextKey: "sendMoney_label_bicSwift",
                              helperAction: { Toast.show(localized("generic_alert_notAvailableOperation")) },
                              accessibilitySuffix: AccessibilitySendMoneyAmountNoSepa.bicSuffix)
        )
        self.oneInpuntSwiftValue.setupTextField(
            OneInputRegularViewModel(status: .activated)
        )
        self.oneInpuntSwiftValue.delegate = self
    }
    
    func setupAccessibilityIds() {
        self.swiftTitle.accessibilityIdentifier = AccessibilitySendMoneyAmountNoSepa.recipientBank
    }
    
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view ?? UIView())
        self.view?.fullFit()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
}

extension SMAmountAllInternationalSwiftView: OneInputRegularViewDelegate {
    func textDidChange(_ text: String) {
        self.delegate?.saveSwift(text)
    }
    
    func shouldReturn() {}
}
