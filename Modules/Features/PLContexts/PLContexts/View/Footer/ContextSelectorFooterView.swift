//
//  ContextSelectorFooterView.swift
//  PLContexts
//

import UIKit
import UI
import Commons
import SANPLLibrary
import PLUI

protocol ContextSelectorFooterViewDelegate: AnyObject {
    func didTapShowAllContexts()
}

final class ContextSelectorFooterView: UIView {
    @IBOutlet weak var showAllContextsButton: UIButton!
    
    public weak var delegate: ContextSelectorFooterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showAllContextsButton.titleLabel?.font = UIFont.santander(family: .micro, type: .bold, size: 14)
        self.showAllContextsButton.tintColor = .darkTorquoise
        self.showAllContextsButton.setImage(PLAssets.image(named: "showMoreContextsArrow"), for: .normal)
        self.showAllContextsButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        self.setAccessibilityIdentifiers()
    }
    
    func configure(_ numberOfHiddenContexts: Int) {
        let showAllContextText = localized("pl_context_label_showAccounts", [StringPlaceholder(.number, "\(numberOfHiddenContexts)")]).text
        self.showAllContextsButton.setTitle(showAllContextText, for: .normal)
    }
    
    @IBAction func showAllContextsAction(_ sender: Any) {
        self.delegate?.didTapShowAllContexts()
    }
}

private extension ContextSelectorFooterView {
    private func setAccessibilityIdentifiers() {
        self.showAllContextsButton.accessibilityIdentifier = AccessibilityContextFooter.btnShowOther
    }
}
