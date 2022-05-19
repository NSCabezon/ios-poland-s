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
import TransferOperatives

protocol SendMoneyAmountAllInternationalView: OperativeView, SendMoneyCurrencyHelperViewProtocol {
    func addAccountSelector(_ viewModel: OneAccountsSelectedCardViewModel)
    func setExchangeRateViewModel(_ viewModel: OneExchangeRateAmountViewModel)
    func setFloatingButtonEnabled(_ isEnabled: Bool)
    func setSwiftText(_ text: String?)
    func setSwiftInfo(countryFlag: String?, bankName: String?, bankAddress: String?)
    func setSwiftError(_ error: SMAmountAllInternationalSwiftError)
    func setDescriptionText(_ text: String?)
    func showSwiftInfoLoading()
    func hideSwiftInfoLoading()
}

final class SendMoneyAmountAllInternationalViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var floatingButton: OneFloatingButton!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
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
    
    private lazy var simpleDateView = SMAmountAllInternationalSimpleDateView()
    
    internal lazy var currenciesSelectionView: SelectionListView = {
        let currenciesSelectionView = SelectionListView()
        currenciesSelectionView.setSelectionType(.currencies)
        currenciesSelectionView.delegate = self
        currenciesSelectionView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        return currenciesSelectionView
    }()

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
        self.exchangeRateView.publisher
            .case(OneExchangeRateAmountViewState.didSelectedShowCurrencies)
            .sink { [unowned self] isTransaccionalOriginCurrency in
                self.presenter.didPressedShowCurrencies(isTransaccionalOriginCurrency)
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
        self.exchangeRateView.setViewModel(viewModel)
    }
    
    func setFloatingButtonEnabled(_ isEnabled: Bool) {
        self.floatingButton.isEnabled = isEnabled
    }
    
    func setSwiftText(_ text: String?) {
        self.swiftView.setSwiftText(text)
    }
    
    func setSwiftInfo(countryFlag: String?, bankName: String?, bankAddress: String?) {
        guard let bankName = bankName,
              let bankAddress = bankAddress else {
            self.swiftView.show(.none)
            return
        }
        self.swiftView.show(.information(flag: countryFlag, text: "\(bankName)\n\(bankAddress)"))
    }
    
    func setSwiftError(_ error: SMAmountAllInternationalSwiftError) {
        self.swiftView.show(.error(error))
    }
    
    func setDescriptionText(_ text: String?) {
        self.descriptionView.setDescriptionText(text)
    }
    
    func showSwiftInfoLoading() {
        _ = self.showJumpingGreenLoadingPublisher()
    }
    
    func hideSwiftInfoLoading() {
        _ = self.dismissJumpingGreenLoadingPublisher()
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
    func didEndEditing(_ swift: String?) {
        self.presenter.saveSwift(swift)
    }
}

extension SendMoneyAmountAllInternationalViewController: SelectionListViewDelegate {
    func didSearchItem(_ searchItem: String) {
        self.presenter.didSearchCurrency(searchItem)
    }
    
    func didSelectItem(_ item: String) {
        self.presenter.didSelectCurrency(item)
    }
}

extension SendMoneyAmountAllInternationalViewController: JumpingGreenCirclesLoadingViewPresentationCapable {}
