//
//  ScanAndPaySummaryViewController.swift
//  ScanAndPay
//
//  Created by 188216 on 07/04/2022.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons
import CoreServices
import UIKit

protocol ScanAndPaySummaryViewProtocol: AnyObject, ErrorPresentable, ConfirmationDialogPresentable {
    func configure(with viewModel: SummaryViewModel)
}

final class ScanAndPaySummaryViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: ScanAndPaySummaryPresenterProtocol
    private let dropdownPresenter: DropdownPresenter
    private let mainStackView = UIStackView()
    private let summaryView = SummaryView()
    private let individualSubmitButtonView = BottomButtonView(style: .red)
    private let companyButtonsStackView = UIStackView()
    private let companySubmitButton = WhiteLisboaButton()
    private let splitPaymentButton = WhiteLisboaButton()
    
    // MARK: Lifecycle
    
    init(presenter: ScanAndPaySummaryPresenterProtocol, dropdownPresenter: DropdownPresenter) {
        self.presenter = presenter
        self.dropdownPresenter = dropdownPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        addSubviews()
        setUpLayout()
        prepareStyles()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .tooltip(
                titleKey: localized("pl_scanAndPay_toolbar_details"),
                type: .red,
                action: { [weak self] sender in
                    self?.showTooltip(from: sender)
                }
            )
        )
            .setLeftAction(.back(action: .selector(#selector(goBack))))
            .setRightActions(.image(image: "icnOptionsMenu", action: .selector(#selector(didTapOptionsMenu))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(summaryView)
        
        companyButtonsStackView.addArrangedSubview(SeparatorView())
        companyButtonsStackView.addArrangedSubview(companySubmitButton)
        companyButtonsStackView.addArrangedSubview(splitPaymentButton)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        companyButtonsStackView.axis = .vertical
        companyButtonsStackView.spacing = 16.0
        companyButtonsStackView.isLayoutMarginsRelativeArrangement = true
        companyButtonsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        
        companySubmitButton.translatesAutoresizingMaskIntoConstraints = false
        splitPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            companySubmitButton.heightAnchor.constraint(equalToConstant: 48.0),
            splitPaymentButton.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        individualSubmitButtonView.configure(title: localized("pl_scanAndPay_button_confirm")) {
            // todo: Implement in another PR
        }
        companySubmitButton.setTitle(localized("#Przelew na rachunek obcy"), for: .normal)
        companySubmitButton.addAction {
            // todo: Implement in another PR
        }
        splitPaymentButton.setTitle(localized("#Płatność podzielona"), for: .normal)
        splitPaymentButton.addAction {
            // todo: Implement in another PR
        }
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func showTooltip(from sender: UIView) {
        let navigationToolTip = ScanAndPayInfoToolTip()
        navigationToolTip.show(in: self, from: sender, completion: {})
    }
    
    @objc private func didTapOptionsMenu() {
        let dropdownItems = [
            DropdownItem(name: localized("pl_scanAndPay_menu_save"), action: { [weak self] in
                self?.didTapSave()
            }),
            DropdownItem(name: localized("pl_scanAndPay_menu_share"), action: { [weak self] in
                self?.didTapShare()
            })
        ]
        
        dropdownPresenter.present(items: dropdownItems, in: self)
    }
    
    private func didTapSave() {
        let summaryImage = summaryView.getSnapshot()
        presenter.handleSaveTouch(with: summaryImage)
    }
    
    private func didTapShare() {
        let summaryImage = summaryView.getSnapshot()
        presenter.handleShareTouch(with: summaryImage)
    }
}

extension ScanAndPaySummaryViewController: ScanAndPaySummaryViewProtocol {
    func configure(with viewModel: SummaryViewModel) {
        summaryView.configure(with: viewModel)
        
        if viewModel.isInCompanyContext {
            mainStackView.addArrangedSubview(companyButtonsStackView)
        } else {
            mainStackView.addArrangedSubview(individualSubmitButtonView)
        }
    }
}
