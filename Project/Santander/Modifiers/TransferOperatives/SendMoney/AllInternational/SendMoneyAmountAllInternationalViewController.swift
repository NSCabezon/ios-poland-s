//
//  SendMoneyAmountAllInternationalViewController.swift
//  TransferOperatives
//
//  Created by José María Jiménez Pérez on 20/4/22.
//

import UIKit
import Operative
import CoreFoundationLib
import UIOneComponents
import UI

protocol SendMoneyAmountAllInternationalView: OperativeView {
    func addAccountSelector(_ viewModel: OneAccountsSelectedCardViewModel)
    func setFloatingButtonEnabled(_ isEnabled: Bool)
}

final class SendMoneyAmountAllInternationalViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var floatingButton: OneFloatingButton!
    
    private let presenter: SendMoneyAmountAllInternationalPresenterProtocol
    
    private lazy var descriptionView: SMAmountAllInternationalDescriptionView = {
        let view = SMAmountAllInternationalDescriptionView()
        view.delegate = self
        return view
    }()
    
    private lazy var swiftView: SMAmountAllInternationalSwiftView = {
        let view = SMAmountAllInternationalSwiftView()
        view.delegate = self
        return view
    }()
    
    private lazy var simpleDateView = SMAmountAllInternationalSimpleDateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFloattingButton()
        self.configureTap()
        self.presenter.viewDidLoad()
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    init(presenter: SendMoneyAmountAllInternationalPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SendMoneyAmountAllInternationalViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SendMoneyAmountAllInternationalViewController {
    func setupNavigationBar() {
        let stepInfo = self.getOperativeStep()
        OneNavigationBarBuilder(.whiteWithRedComponents)
            .setTitle(withKey: "toolbar_title_amountAndDate")
            .setAccessibilityTitleValue(value: localized("siri_voiceover_step",
                                                         [StringPlaceholder(.number, stepInfo[0]),
                                                          StringPlaceholder(.number, stepInfo[1])]).text)
            .setLeftAction(.back, customAction: {
                self.presenter.didSelectBack()
            })
            .setRightAction(.help, action: {
                Toast.show(localized("generic_alert_notAvailableOperation"))
            })
            .setRightAction(.close, action: {
                self.presenter.didSelectClose()
            })
            .build(on: self)
    }
    
    func configureViews() {
        // TODO: add here new oneExangeView
        self.stackView.addArrangedSubview(self.swiftView)
        self.stackView.addArrangedSubview(self.descriptionView)
        self.stackView.addArrangedSubview(self.simpleDateView)
    }
    
    func configureFloattingButton() {
        self.floatingButton.configureWith(
            type: .primary,
            size: .large(
                OneFloatingButton.ButtonSize.LargeButtonConfig(title: localized("generic_button_continue"),
                                                            subtitle: self.presenter.getSubtitleInfo(),
                                                            icons: .right, fullWidth: false)),
            status: .ready)
        self.floatingButton.addTarget(self, action: #selector(floatingButtonDidPressed), for: .touchUpInside)
    }
    
    func configureTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func getOperativeStep() -> [String]{
        let stepOfSteps = self.presenter.getStepOfSteps()
        let step = String(stepOfSteps[0])
        let total = String(stepOfSteps[1])
        return [step, total]
    }
    
    @objc func floatingButtonDidPressed() {
        guard self.floatingButton.isEnabled else { return }
        self.presenter.didSelectContinue()
    }
}

extension SendMoneyAmountAllInternationalViewController: SendMoneyAmountAllInternationalView {
    var operativePresenter: OperativeStepPresenterProtocol {
        return self.presenter
    }
    
    func addAccountSelector(_ viewModel: OneAccountsSelectedCardViewModel) {
        let oneAccountsSelectedCardView = OneAccountsSelectedCardView()
        let oneCardSelectedContainerView = UIView()
        oneCardSelectedContainerView.addSubview(oneAccountsSelectedCardView)
        oneAccountsSelectedCardView.fullFit(leftMargin: 16, rightMargin: 16)
        oneAccountsSelectedCardView.delegate = self
        oneAccountsSelectedCardView.setupAccountViewModel(viewModel)
        oneAccountsSelectedCardView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(oneCardSelectedContainerView)
    }
    
    func setFloatingButtonEnabled(_ isEnabled: Bool) {
        self.floatingButton.isEnabled = isEnabled
    }
}

extension SendMoneyAmountAllInternationalViewController: OneAccountsSelectedCardDelegate {
    func didSelectOriginButton() {
        self.presenter.changeOriginAccount()
    }
    
    func didSelectDestinationButton() {
        self.presenter.changeDestinationAccount()
    }
}

extension SendMoneyAmountAllInternationalViewController: SMAmountAllInternationalDescriptionViewDelegate {
    func saveDescription(_ description: String?) {
        self.presenter.saveDescription(description)
    }
}

extension SendMoneyAmountAllInternationalViewController: SMAmountAllInternationalSwiftViewDelegate {
    func saveSwift(_ swift: String?) {
        self.presenter.saveSwift(swift)
    }
}
