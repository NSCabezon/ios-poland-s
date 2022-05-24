//
//  SMAmountAllInternationalDescriptionView.swift
//  TransferOperatives
//
//  Created by José María Jiménez Pérez on 22/4/22.
//

import UI
import UIOneComponents
import CoreFoundationLib
import UIKit

protocol SMAmountAllInternationalDescriptionViewDelegate: AnyObject {
    func saveDescription(_ description: String?)
}

final class SMAmountAllInternationalDescriptionView: UIView {
    
    private var view: UIView?
    
    @IBOutlet private weak var oneLabelDescription: OneLabelView!
    @IBOutlet private weak var oneInputDescription: OneInputRegularView!
    
    weak var delegate: SMAmountAllInternationalDescriptionViewDelegate?
    
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
    
    func setDescriptionText(_ text: String?) {
        self.oneInputDescription.setInputText(text)
    }
}

private extension SMAmountAllInternationalDescriptionView {
    func setupViews() {
        self.xibSetup()
        self.oneLabelDescription.setupViewModel(
            OneLabelViewModel(type: .counter,
                              mainTextKey: "sendMoney_label_description",
                              actualCounterLabel: "0",
                              maxCounterLabel: "140")
        )
        self.oneInputDescription.setupTextField(
            OneInputRegularViewModel(status: .activated, placeholder: "sendMoney_hint_description")
        )
        self.oneInputDescription.maxCounter = 140
        self.oneInputDescription.regularExpression = try? NSRegularExpression(pattern: "[a-zA-Z0-9ąćęłńóśźżĄĆĘŁŃÓŚŹŻ`!@#$%^&*()_+-=\\[\\]{};:,.?/ –\\\\]+$")
        self.oneInputDescription.charactersDelegate = self
        self.oneInputDescription.delegate = self
    }
    
    func setupAccessibilityIds() {
        
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

extension SMAmountAllInternationalDescriptionView: OneInputRegularCharactersDelegate {
    func updateNumberOfCharacters(_ total: Int) {
        self.oneLabelDescription.setActualCounterLabel(String(total))
    }
}

extension SMAmountAllInternationalDescriptionView: OneInputRegularViewDelegate {
    func textDidChange(_ text: String) {
        self.delegate?.saveDescription(text)
    }
    
    func shouldReturn() {}
}
