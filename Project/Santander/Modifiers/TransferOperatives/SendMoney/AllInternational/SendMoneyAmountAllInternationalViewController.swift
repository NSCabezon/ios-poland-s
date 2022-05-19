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
    func setDescriptionText(_ text: String?)
    func addSelectDateOneContainerView(_ viewModel: SelectDateOneContainerViewModel, isSelectDeadlineCheckbox: Bool, endDate: Date?)
    func setSimpleDate(_ isSimple: Bool)
    func setHiddenSwiftView(_ isHiden: Bool)
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
    
    private lazy var swiftInfoView: OneAlertView = {
        // TODO: TRAERSE DEVELOP PARA TENER DISPONIBLE LO ÚLTIMO DEL COMPONENTE
        let view = OneAlertView()
        view.setType(.textAndImage(imageKey: "oneIcnFlagSpain", stringKey: "Santander Consumer Bank SA\nCentrala\n42 C, UL. Strzegomska\n53-611 Wroclaw, Poland"))
        return view
    }()
    
    private lazy var swiftInfoContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.swiftInfoView)
        self.swiftInfoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0).isActive = true
        self.swiftInfoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0).isActive = true
        self.swiftInfoView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0).isActive = true
        self.swiftInfoView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: .zero).isActive = true
        return container
    }()
    
    private lazy var simpleDateView = SMAmountAllInternationalSimpleDateView()
    private let selectDateOneContainerView = SelectDateOneContainerView()
    
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
        self.stackView.addArrangedSubview(self.swiftInfoContainerView)
        self.stackView.addArrangedSubview(self.exchangeRateContainerView)
        self.stackView.addArrangedSubview(self.descriptionView)
        self.stackView.addArrangedSubview(self.simpleDateView)
        self.stackView.addArrangedSubview(self.selectDateOneContainerView)
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
        // TODO: SETEAR EN EL ONEALERT
        guard let bankName = bankName,
              let bankAddress = bankAddress else {
                  self.swiftInfoContainerView.isHidden = true
                  return
              }
        self.swiftInfoContainerView.isHidden = false
        // TODO: CHANGE
        self.swiftInfoView.setType(.textAndImage(imageKey: countryFlag ?? "", stringKey: "\(bankName)\n\(bankAddress)"))
    }
    
    func setDescriptionText(_ text: String?) {
        self.descriptionView.setDescriptionText(text)
    }
    
    func addSelectDateOneContainerView(_ viewModel: SelectDateOneContainerViewModel, isSelectDeadlineCheckbox: Bool, endDate: Date?) {
        self.selectDateOneContainerView.delegate = self
        self.selectDateOneContainerView.setViewModels(viewModel, isSelectDeadlineCheckbox: isSelectDeadlineCheckbox, endDate: endDate)
        self.selectDateOneContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setSimpleDate(_ isSimple: Bool) {
        self.simpleDateView.isHidden = !isSimple
        self.selectDateOneContainerView.isHidden = isSimple
    }
    
    func setHiddenSwiftView(_ isHiden: Bool) {
        self.swiftView.isHidden = isHiden
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
    
    func reloadSwiftInfo() {
        self.presenter.reloadSwiftInfo()
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

extension SendMoneyAmountAllInternationalViewController: SelectDateOneContainerViewDelegate {
    
    func didSelecteOneFilterSegment(_ type: SendMoneyDateTypeViewModel) {
        self.presenter.didSelecteOneFilterSegment(type)
    }
    
    func didSelectIssueDate(_ date: Date) {
        self.presenter.didSelectIssueDate(date)
    }
    
    func getSendMoneyPeriodicity(_ index: Int) -> SendMoneyPeriodicityTypeViewModel {
        return .month
    }
    
    func didSelectDeadlineCheckbox(_ isDeadLine: Bool) {}
    func didSelectFrequency(_ type: SendMoneyPeriodicityTypeViewModel) {}
    func didSelectBusinessDay(_ type: SendMoneyEmissionTypeViewModel) {}
    func didSelectStartDate(_ date: Date) {}
    func didSelectEndDate(_ date: Date) {}
}
