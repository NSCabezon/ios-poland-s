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
import OpenCombine

protocol SendMoneyAmountAllInternationalView: OperativeView {
    func addAccountSelector(_ viewModel: OneAccountsSelectedCardViewModel)
    func setExchangeRateViewModel(_ viewModel: OneExchangeRateAmountViewModel)
    func setFloatingButtonEnabled(_ isEnabled: Bool)
}

final class SendMoneyAmountAllInternationalViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var floatingButton: OneFloatingButton!
    
    private let presenter: SendMoneyAmountAllInternationalPresenterProtocol
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var exchangeRateView: OneExchangeRateAmountView = {
        let view = OneExchangeRateAmountView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureText(withKey: "sendMoney_label_amoundDate")
        label.textColor = .oneLisboaGray
        label.font = .typography(fontName: .oneH100Bold)
        return label
    }()
    
    private lazy var exchangeRateContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.exchangeRateLabel)
        container.addSubview(self.exchangeRateView)
        NSLayoutConstraint.activate([
            self.exchangeRateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            self.exchangeRateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            self.exchangeRateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            self.exchangeRateView.topAnchor.constraint(equalTo: self.exchangeRateLabel.bottomAnchor, constant: 24),
            self.exchangeRateView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            self.exchangeRateView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            self.exchangeRateView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
        return container
    }()
    
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
    
    private lazy var swiftInfoView: OneAlertView = {
        // TODO: TRAERSE DEVELOP PARA TENER DISPONIBLE LO ÚLTIMO DEL COMPONENTE
        let view = OneAlertView()
        view.setType(.textAndImage(imageKey: "Santander Consumer Bank SA\nCentrala\n42 C, UL. Strzegomska\n53-611 Wroclaw, Poland", stringKey: "oneIcnFlagSpain"))
        return view
    }()
    
    private lazy var simpleDateView = SMAmountAllInternationalSimpleDateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFloattingButton()
        self.configureTap()
        self.presenter.viewDidLoad()
        self.configureViews()
        self.bindViews()
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
        self.stackView.addArrangedSubview(self.swiftView)
        self.stackView.addArrangedSubview(self.swiftInfoView)
        self.stackView.addArrangedSubview(self.exchangeRateContainerView)
        self.stackView.addArrangedSubview(self.descriptionView)
        self.stackView.addArrangedSubview(self.simpleDateView)
    }
    
    func bindViews() {
        self.exchangeRateView.publisher
            .case(OneExchangeRateAmountViewState.didChangeOriginAmount)
            .sink { [unowned self] (originAmount, newDestinationAmount) in
                self.presenter.saveAmounts(originAmount: originAmount, destinationAmount: newDestinationAmount)
            }
            .store(in: &subscriptions)
        
        self.exchangeRateView.publisher
            .case(OneExchangeRateAmountViewState.didChangeDestinationAmount)
            .sink { [unowned self] (newOriginAmount, destinationAmount) in
                self.presenter.saveAmounts(originAmount: newOriginAmount, destinationAmount: destinationAmount)
            }
            .store(in: &subscriptions)
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
    
    func getOperativeStep() -> [String] {
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
    
    func setExchangeRateViewModel(_ viewModel: OneExchangeRateAmountViewModel) {
        guard case .exchange(let destination) = viewModel.type else { return }
        self.exchangeRateView.setViewModel(
            OneExchangeRateAmountViewModel(originAmount: viewModel.originAmount,
                                           type: .exchange(destinationAmount:
                                                            OneExchangeRateAmount(amount: destination.amount, buyRate: destination.buyRate, sellRate: destination.sellRate, currencySelector: UIView())
                                                          ),
                                           alert: OneExchangeRateAmountAlert(iconName: "icnInfo", titleKey: "sendMoney_label_conversionExchangeRate")
                                          )
        )
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
