//
//  ChequeListViewController.swift
//  Account
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import UIKit
import UI
import Commons
import PLUI
import PLCommons

protocol ChequeListViewProtocol: LoadingViewPresentationCapable, DialogViewPresentationCapable {
    func setViewModel(_ viewModel: ChequeViewModelType)
    func enableCreateChequeButton()
    func disableCreateChequeButton()
}

final class ChequeListViewController: UIViewController {
    private let tableView = UITableView()
    private let bottomButton = BottomButtonView()
    private let refreshControl = UIRefreshControl()
    private let shouldShowCreateChequeButton: Bool
    private var viewModel: ChequeViewModelType = .cheques([])
    private let presenter: ChequeListPresenterProtocol
    
    init(
        presenter: ChequeListPresenterProtocol,
        shouldShowCreateChequeButton: Bool
    ) {
        self.presenter = presenter
        self.shouldShowCreateChequeButton = shouldShowCreateChequeButton
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    private func setUp() {
        configureSubviews()
        configureTableView()
        configureStyling()
        configureBottomButton()
        setIdentifiers()
    }
    
    private func configureSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        if shouldShowCreateChequeButton {
            view.addSubview(bottomButton)
            bottomButton.translatesAutoresizingMaskIntoConstraints = false

            constraints += [
                bottomButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
                bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        } else {
            constraints += [
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.register(ChequeCell.self, forCellReuseIdentifier: ChequeCell.identifier)
        tableView.register(EmptyDataMessageCell.self, forCellReuseIdentifier: EmptyDataMessageCell.identifier)
        tableView.register(ErrorCell.self, forCellReuseIdentifier: ErrorCell.identifier)
        refreshControl.isEnabled = false
        refreshControl.addTarget(
            self,
            action: #selector(didPullRefreshControl),
            for: .valueChanged
        )
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureBottomButton() {
        bottomButton.configure(title: localized("pl_blik_button_createCheque")) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presenter.didPressCreateCheque()
        }
    }
    
    @objc private func didPullRefreshControl() {
        refreshControl.isEnabled = false
        presenter.didPullToRefresh { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.refreshControl.endRefreshing()
                strongSelf.refreshControl.isEnabled = true
            }
        }
    }
    
    private func setIdentifiers() {
        tableView.accessibilityIdentifier = AccessibilityCheques.ChequeList.tableView.id
        bottomButton.accessibilityIdentifier = AccessibilityCommons.BottomButtonView.root.id
        refreshControl.accessibilityIdentifier = AccessibilityCheques.ChequeList.refreshControl.id
    }
}

extension ChequeListViewController: ChequeListViewProtocol {
    func setViewModel(_ viewModel: ChequeViewModelType) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.tableView.reloadData()
            self.refreshControl.isEnabled = true
            self.refreshControl.endRefreshing()
        }
    }
    
    func enableCreateChequeButton() {
        bottomButton.enableButton()
    }
    
    func disableCreateChequeButton() {
        bottomButton.disableButton()
    }
}

extension ChequeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel {
        case let .cheques(viewModels):
            return viewModels.count
        case .emptyDataMessage, .error:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel {
        case let .cheques(viewModels):
            return chequeCell(for: viewModels, at: indexPath)
        case let .emptyDataMessage(viewModel):
            return emptyDataMessageCell(for: viewModel, at: indexPath)
        case let .error(viewModel):
            return errorCell(for: viewModel, at: indexPath)
        }
    }
    
    private func emptyDataMessageCell(
        for viewModel: EmptyDataMessageViewModel,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmptyDataMessageCell.identifier,
            for: indexPath
        ) as? EmptyDataMessageCell else {
            return UITableViewCell()
        }
        
        cell.accessibilityIdentifier = AccessibilityCheques.EmptyDataMessageCell.root.id
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func chequeCell(
        for viewModels: [ChequeViewModel],
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChequeCell.identifier,
            for: indexPath
        ) as? ChequeCell else {
            return UITableViewCell()
        }
        
        cell.accessibilityIdentifier = AccessibilityCheques.ChequeCell.root.id + ".\(indexPath.row)"
        cell.setViewModel(viewModels[indexPath.row])
        return cell
    }
    
    private func errorCell(
        for viewModel: ErrorCellViewModel,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ErrorCell.identifier,
            for: indexPath
        ) as? ErrorCell else {
            return UITableViewCell()
        }
        
        cell.accessibilityIdentifier = AccessibilityCheques.ErrorCell.root.id
        cell.setViewModel(viewModel)
        return cell
    }
}

extension ChequeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel {
        case let .cheques(viewModels):
            let viewModel = viewModels[indexPath.row]
            presenter.didSelectCheque(withId: viewModel.id)
        case .emptyDataMessage, .error:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel {
        case .cheques:
            return 81
        case .emptyDataMessage, .error:
            return UITableView.automaticDimension
        }
    }
}
