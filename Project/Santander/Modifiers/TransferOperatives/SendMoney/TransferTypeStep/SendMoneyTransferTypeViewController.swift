//
//  SendMoneyTransferTypeViewController.swift
//  TransferOperatives
//
//  Created by José Norberto Hidalgo on 29/9/21.
//

import UIOneComponents
import Operative
import Commons
import CoreFoundationLib
import UIKit
import UI

protocol SendMoneyTransferTypeView: OperativeView {
    func showTransferTypes(viewModel: SendMoneyTransferTypeRadioButtonsContainerViewModel)
    func setBottomInformationTextKey(_ key: String)
    func showAmountTooHighView()
    func closeAmountTooHighView()
}

final class SendMoneyTransferTypeViewController: UIViewController {
    private enum Constants {
        static let nibName: String = "SendMoneyTransferTypeViewController"
        enum NavigationBar {
            static let titleKey: String = "toolbar_title_sendType"
        }
        enum MainStackView {
            static let margins = UIEdgeInsets(
                top: 20.0,
                left: 16.0,
                bottom: .zero,
                right: 16.0
            )
        }
        enum TitleLabel {
            static let textKey: String = "sendMoney_label_sentType"
            static let bottomSpace: CGFloat = 20.0
        }
        enum RadioButtonsContainer {
            static let bottomSpace: CGFloat = 16.0
        }
        enum ContinueButton {
            static let titleKey: String = "generic_button_continue"
        }
    }
    
    let presenter: SendMoneyTransferTypePresenterProtocol
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var floatingButton: OneFloatingButton!
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = .zero
        titleLabel.font = .typography(fontName: .oneH100Bold)
        titleLabel.textColor = .oneLisboaGray
        titleLabel.configureText(withKey: Constants.TitleLabel.textKey)
        return titleLabel
    }()
    private lazy var radioButtonsContainer: SendMoneyTransferTypeRadioButtonsContainerView = {
        let radioButtonsContainer = SendMoneyTransferTypeRadioButtonsContainerView()
        radioButtonsContainer.delegate = self
        return radioButtonsContainer
    }()
    private lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.numberOfLines = .zero
        bottomLabel.font = .typography(fontName: .oneB200Regular)
        bottomLabel.textColor = .oneLisboaGray
        return bottomLabel
    }()
    private lazy var amountHighView: SendMoneyTransferTypeAmountHighView = {
        let amountHighView = SendMoneyTransferTypeAmountHighView()
        amountHighView.delegate = self
        return amountHighView
    }()
    private lazy var bottomSheet: BottomSheet = {
        return BottomSheet()
    }()
    
    init(presenter: SendMoneyTransferTypePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: Constants.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.setupNavigationBar()
        self.setupStackView()
        self.setAccessibilityIdentifiers()
        self.presenter.viewDidLoad()
    }
}

private extension SendMoneyTransferTypeViewController {
    func setupNavigationBar() {
        OneNavigationBarBuilder(.whiteWithRedComponents)
            .setTitle(withKey: Constants.NavigationBar.titleKey)
            .setLeftAction(.back, customAction: self.didTapBack)
            .setRightAction(.help) {
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
            .setRightAction(.close, action: self.presenter.didSelectClose)
            .build(on: self)
    }
    
    func didTapBack() {
        self.presenter.didSelectBack()
    }
    
    func setupComponents() {
        self.floatingButton.configureWith(
            type: .primary,
            size: .large(
                OneFloatingButton.ButtonSize.LargeButtonConfig(
                    title: localized(Constants.ContinueButton.titleKey),
                    subtitle: self.presenter.getSubtitleInfo(),
                    icons: .right,
                    fullWidth: false
                )
            ),
            status: .ready
        )
        self.floatingButton.isEnabled = true
        self.floatingButton.addTarget(self, action: #selector(floatingButtonDidPressed), for: .touchUpInside)
    }
    
    func setupStackView() {
        self.mainStackView.isLayoutMarginsRelativeArrangement = true
        self.mainStackView.layoutMargins = Constants.MainStackView.margins
        self.mainStackView.addArrangedSubview(self.titleLabel)
        self.mainStackView.setCustomSpacing(Constants.TitleLabel.bottomSpace, after: self.titleLabel)
        self.mainStackView.addArrangedSubview(self.radioButtonsContainer)
        self.mainStackView.setCustomSpacing(Constants.RadioButtonsContainer.bottomSpace, after: radioButtonsContainer)
    }

    func setAccessibilityIdentifiers() {
        self.titleLabel.accessibilityIdentifier = Constants.TitleLabel.textKey
    }

    @objc func floatingButtonDidPressed() {
        self.presenter.didPressedFloatingButton()
    }
}

extension SendMoneyTransferTypeViewController: SendMoneyTransferTypeView {
    var operativePresenter: OperativeStepPresenterProtocol {
        return self.presenter
    }
    
    func showTransferTypes(viewModel: SendMoneyTransferTypeRadioButtonsContainerViewModel) {
        self.radioButtonsContainer.setViewModel(viewModel)
    }
    
    func showAmountTooHighView() {
        self.bottomSheet.show(
            in: self,
            type: .custom(height: nil, isPan: true, bottomVisible: true),
            component: .all,
            view: self.amountHighView
        )
    }
    
    func setBottomInformationTextKey(_ key: String) {
        self.bottomLabel.configureText(withKey: key)
        self.bottomLabel.accessibilityIdentifier = key
        self.mainStackView.addArrangedSubview(self.bottomLabel)
    }
    
    func closeAmountTooHighView() {
        self.presentedViewController?.dismiss(animated: true)
    }
}

extension SendMoneyTransferTypeViewController: SendMoneyTransferTypeRadioButtonsContainerViewDelegate {
    func didSelectRadioButton(at index: Int) {
        self.presenter.didSelectTransferType(at: index)
    }
}

extension SendMoneyTransferTypeViewController: SendMoneyTransferTypeAmountHighViewDelegate {
    func didTapActionButton() {
        self.presenter.didTapCloseAmountHigh()
    }
}
