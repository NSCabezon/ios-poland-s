//
//  SMAmountAllInternationalSimpleDateView.swift
//  TransferOperatives
//
//  Created by José María Jiménez Pérez on 27/4/22.
//

import CoreFoundationLib
import UI
import UIKit

final class SMAmountAllInternationalSimpleDateView: UIView {
    
    private var view: UIView?
    
    @IBOutlet private weak var dateSendingLabel: UILabel!
    @IBOutlet private weak var dateSendingValue: UILabel!
    
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
}

private extension SMAmountAllInternationalSimpleDateView {
    func setupViews() {
        self.xibSetup()
        self.dateSendingLabel.font = .typography(fontName: .oneB300Regular)
        self.dateSendingLabel.textColor = .oneLisboaGray
        self.dateSendingLabel.configureText(withKey: "sendMoney_label_dateSending")
        self.dateSendingValue.font = .typography(fontName: .oneB400Bold)
        self.dateSendingValue.textColor = .oneLisboaGray
        self.dateSendingValue.configureText(withKey: "sendMoney_label_today")
    }
    
    func setupAccessibilityIds() {
        self.dateSendingLabel.accessibilityIdentifier = AccessibilitySendMoneyAmountNoSepa.dateSending
        self.dateSendingValue.accessibilityIdentifier = AccessibilitySendMoneyAmountNoSepa.dateSendingToday
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
