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

enum SMAmountAllInternationalSwiftContent {
    case none
    case information(flag: String?, text: String)
    case error(SMAmountAllInternationalSwiftError)
}

enum SMAmountAllInternationalSwiftError {
    case invalidLength
    case invalidSwift
}

protocol SMAmountAllInternationalSwiftViewDelegate: AnyObject {
    func didEndEditing(_ swift: String?)
}

final class SMAmountAllInternationalSwiftView: UIView {
    
    private var view: UIView?
    
    @IBOutlet private weak var swiftTitle: UILabel!
    @IBOutlet private weak var oneLabelSwiftTitle: OneLabelView!
    @IBOutlet private weak var oneInpuntSwiftValue: OneInputRegularView!
    @IBOutlet private weak var swiftErrorIcon: UIImageView!
    @IBOutlet private weak var swiftErrorLabel: UILabel!
    @IBOutlet private weak var swiftErrorContainer: UIView!
    @IBOutlet private weak var swiftInfoAlertTopSpaceView: UIView!
    @IBOutlet private weak var swiftInfoAlert: OneAlertView!
    
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
    
    func show(_ content: SMAmountAllInternationalSwiftContent) {
        switch content {
        case .none: self.showNone()
        case .information(let flag, let text): self.showInfo(flag: flag, text: text)
        case .error(let error): self.showError(error)
        }
    }
}

private extension SMAmountAllInternationalSwiftView {
    enum Constants {
        enum Errors {
            static let invalidSwiftKey: String = "sendMoney_alert_enterValidBicSwift"
            static let lengthKey: String = "sendMoney_alert_invalidCharactersBicSwift"
        }
        enum SwiftInfo {
            static let titleKey: String = "sendMoney_label_recipientBankAddress"
            static let backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
            static let cornerRadius: CGFloat = 4.0
        }
    }
    
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
            OneInputRegularViewModel(status: .activated,
                                     accessibilitySuffix: AccessibilitySendMoneyAmountNoSepa.bicSuffix)
        )
        self.oneInpuntSwiftValue.delegate = self
        self.swiftErrorIcon.image = Assets.image(named: "oneIcnAlert")
        self.swiftErrorLabel.font = .typography(fontName: .oneB300Regular)
        self.swiftErrorLabel.textColor = .oneSantanderRed
        self.swiftErrorContainer.isHidden = true
    }
    
    func setupAccessibilityIds() {
        self.swiftTitle.accessibilityIdentifier = AccessibilitySendMoneyAmountNoSepa.recipientBank
        self.swiftErrorIcon.accessibilityIdentifier = AccessibilitySendMoneyAmountNoSepa.errorIcon
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
    
    func showNone() {
        self.swiftErrorContainer.isHidden = true
        self.swiftInfoAlert.isHidden = true
        self.swiftInfoAlertTopSpaceView.isHidden = true
    }
    
    func showInfo(flag: String?, text: String) {
        self.swiftInfoAlert.setType(OneAlertType.textAndImage(imageKey: flag ?? "",
                                                             titleKey: Constants.SwiftInfo.titleKey, stringKey: text,
                                                             style: OneAlertStyle(backgroundColor: Constants.SwiftInfo.backgroundColor,
                                                                                  cornerRadius: Constants.SwiftInfo.cornerRadius)))
        self.swiftErrorContainer.isHidden = true
        self.swiftInfoAlert.isHidden = false
        self.swiftInfoAlertTopSpaceView.isHidden = false
    }
    
    func showError(_ error: SMAmountAllInternationalSwiftError) {
        let errorKey: String = {
            switch error {
            case .invalidLength: return Constants.Errors.lengthKey
            case .invalidSwift: return Constants.Errors.invalidSwiftKey
            }
        }()
        self.swiftErrorLabel.configureText(withKey: errorKey)
        self.swiftErrorLabel.accessibilityIdentifier = errorKey
        self.swiftErrorContainer.isHidden = false
        self.swiftInfoAlertTopSpaceView.isHidden = true
        self.swiftInfoAlert.isHidden = true
    }
}

extension SMAmountAllInternationalSwiftView: OneInputRegularViewDelegate {
    func textDidChange(_ text: String) {}
    
    func shouldReturn() {}
    
    func didEndEditing(_ view: OneInputRegularView) {
        self.delegate?.didEndEditing(view.getInputText())
    }
}
