//
//  BottomSheetErrorView.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 10/11/21.
//

import UI
import UIOneComponents
import CoreFoundationLib
import PLCommons
import PLUI

public protocol BottomSheetErrorDelegate: AnyObject {
    func didTapCancelError()
    func didTapAcceptError()
}

public final class BottomSheetErrorView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var cancelButton: OneFloatingButton!
    @IBOutlet private weak var acceptButton: OneFloatingButton!
    weak var delegate: BottomSheetErrorDelegate?
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetup()
    }
    
    public func setViewModel(_ viewModel: BottomSheetErrorViewModel) {
        self.configureImage(viewModel)
        self.configureLabels(viewModel)
        self.configureLeftButton(viewModel)
        self.configureRightButton(viewModel)
        self.setAccessibilityIdentifiers(viewModel)
    }
}

private extension BottomSheetErrorView {
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view ?? UIView())
        self.view?.fullFit()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
    
    func configureImage(_ viewModel: BottomSheetErrorViewModel) {
        self.imageView.image = Assets.image(named: viewModel.imageKey)
        self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = .oneLisboaGray
    }
    
    func configureLabels(_ viewModel: BottomSheetErrorViewModel) {
        self.titleLabel.configureText(withKey: viewModel.titleKey)
        self.titleLabel.font = .typography(fontName: .oneH300Bold)
        self.titleLabel.textColor = .oneLisboaGray
        self.textLabel.configureText(withKey: viewModel.textKey)
        self.textLabel.font = .typography(fontName: .oneB400Regular)
        self.textLabel.textColor = .lisboaGray
        self.textLabel.numberOfLines = 2
    }
    
    func configureLeftButton(_ viewModel: BottomSheetErrorViewModel) {
        guard let leftButtonKey = viewModel.leftButtonKey else {
            self.cancelButton.isHidden = true
            return
        }
        self.cancelButton.configureWith(
            type: .secondary,
            size: .medium(
                OneFloatingButton.ButtonSize.MediumButtonConfig(title: localized(leftButtonKey),
                                                             icons: .none, fullWidth: true)),
            status: .ready)
        self.cancelButton.isEnabled = true
        self.cancelButton.addTarget(self, action: #selector(cancelButtonDidPress), for: .touchUpInside)
    }
    
    func configureRightButton(_ viewModel: BottomSheetErrorViewModel) {
        self.acceptButton.configureWith(
            type: .primary,
            size: .medium(
                OneFloatingButton.ButtonSize.MediumButtonConfig(title: localized(viewModel.mainButtonKey),
                                                             icons: .none, fullWidth: true)),
            status: .ready)
        self.acceptButton.isEnabled = true
        self.acceptButton.addTarget(self, action: #selector(acceptButtonDidPress), for: .touchUpInside)
    }
    
    @objc func cancelButtonDidPress() {
        self.delegate?.didTapCancelError()
    }
    
    @objc func acceptButtonDidPress() {
        self.delegate?.didTapAcceptError()
    }
    
    func setAccessibilityIdentifiers(_ viewModel: BottomSheetErrorViewModel) {
        self.imageView.accessibilityIdentifier = viewModel.imageKey
        self.titleLabel.accessibilityIdentifier = viewModel.titleKey
        self.textLabel.accessibilityIdentifier = viewModel.textKey
        self.cancelButton.accessibilityIdentifier = AccessibilityAuthorization.bottomSheetLeftBtn
        self.acceptButton.accessibilityIdentifier = AccessibilityAuthorization.bottomSheetRightBtn
    }
}
