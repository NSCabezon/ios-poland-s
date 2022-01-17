//
//  TopUpConfirmationViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 13/01/2022.
//

import Commons
import Operative
import UI
import PLUI

protocol TopUpConfirmationViewProtocol: AnyObject, ConfirmationDialogPresentable {
}

final class TopUpConfirmationViewController: UIViewController {
    // MARK: properties
    
    private let presenter: TopUpConfirmationPresenterProtocol
    private let mainStackView = UIStackView()
    private let summaryContainerView = UIView()
    private let summaryView = OperativeSummaryStandardBodyView()
    private let bottomButtonView = BottomButtonView(style: .red)
    
    // MARK: Lifecycle
    
    init(presenter: TopUpConfirmationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        addSubviews()
        setUpLayout()
        prepareStyles()
        setUpSummaryView()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_topup_title_summary")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(summaryContainerView)
        mainStackView.addArrangedSubview(bottomButtonView)
        
        summaryContainerView.addSubview(summaryView)
        
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 0.0
        
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor, constant: 16.0),
            summaryView.trailingAnchor.constraint(equalTo: summaryContainerView.trailingAnchor, constant: 0.0),
            summaryView.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 0.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .skyGray
        summaryContainerView.backgroundColor = .clear
        
        bottomButtonView.configure(title: localized("pl_topup_button_topup")) { [weak self] in
            #warning("todo: implement api call in another PR")
        }
    }
    
    private func setUpSummaryView() {
        summaryView.setupItems(presenter.summaryBodyItemsModels(), collapsableSections: .noCollapsable)
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func closeProcess() {
        presenter.didSelectClose()
    }
}

extension TopUpConfirmationViewController: TopUpConfirmationViewProtocol {
}
