//
//  TaxTransferConfirmationViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 28/03/2022.
//

import UI
import PLUI
import Operative
import CoreFoundationLib
import Foundation
import PLCommons

protocol TaxTransferConfirmationView: AnyObject,
                                      ErrorPresentable,
                                      LoaderPresentable,
                                      ConfirmationDialogPresentable {
    func set(viewModel: TaxTransferConfirmationViewModel)
}

final class TaxTransferConfirmationViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let summaryView = OperativeSummaryStandardBodyView()
    private let footer = SummaryTotalAmountView()
    private let bottomView = BottomButtonView()
    private let model: TaxTransferModel
    private let presenter: TaxTransferConfirmationPresenterProtocol
    private let confirmationDialogFactory: ConfirmationDialogProducing
    
    init(confirmationDialogFactory: ConfirmationDialogProducing,
         model: TaxTransferModel,
         presenter: TaxTransferConfirmationPresenterProtocol) {
        self.confirmationDialogFactory = confirmationDialogFactory
        self.model = model
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        presenter.viewDidLoad()
    }
}

extension TaxTransferConfirmationViewController: TaxTransferConfirmationView {
    func set(viewModel: TaxTransferConfirmationViewModel) {
        summaryView.setupWithItems(
            viewModel.items,
            actions: [],
            collapsableSections: .noCollapsable
        )
        let amount = PLAmountFormatter.amountString(
            amount: viewModel.amount,
            currency: .złoty,
            withAmountSize: 36.0
        )
        footer.setAmount(amount)
        footer.setTitle(localized("pl_generic_label_total"))
    }
}

private extension TaxTransferConfirmationViewController {
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        setUpLayout()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [summaryView,
         footer].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(bottomView)
    }

    func prepareStyles() {
        view.backgroundColor = .skyGray

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 0, bottom: 59, right: 0)

        bottomView.backgroundColor = .white
        bottomView.configure(title: localized("generic_button_confirm")) { [weak self] in
            self?.presenter.confirmTapped()
        }
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .custom(
                background: .color(UIColor.skyGray),
                tintColor: .santanderRed),
            title: .title(key: localized("genericToolbar_title_confirmation"))
        )
        .setLeftAction(.back(action: .selector(#selector(back))))
        .setRightActions(.close(action: .selector(#selector(close))))
        .build(on: self, with: nil)
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    @objc func back() {
        presenter.didPressBack()
    }

    func setUpLayout() {
        [scrollView,
         stackView,
         bottomView,
         footer
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // temporary solution, change it when OperativeSummaryStandardBodyView's constraints are fixed
            footer.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: -46)
        ])
    }
}
