//
//  AliasListSettingsViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 31/08/2021.
//

import Commons
import UI
import PLUI
import PLCommons

protocol AliasListSettingsView: AnyObject, LoaderPresentable, ErrorPresentable {
    func setViewModels(_ viewModels: [AliasListSettingsViewModel])
    func reloadView()
}

final class AliasListSettingsViewController: UIViewController {
    private let presenter: AliasListSettingsPresenterProtocol
    private let tableView = UITableView()
    private var viewModels: [AliasListSettingsViewModel] = []
    
    init(
        presenter: AliasListSettingsPresenterProtocol
    ) {
        self.presenter = presenter
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
}

extension AliasListSettingsViewController: AliasListSettingsView {
    func setViewModels(_ viewModels: [AliasListSettingsViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = viewModels
            self.tableView.reloadData()
        }
    }
    
    func reloadView() {
        presenter.didTriggerReload()
    }
}

extension AliasListSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModels[indexPath.row] {
        case let .alias(viewModel):
            presenter.didSelectAlias(viewModel.associatedModel)
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.row] {
        case let .header(message):
            return headerCell(with: message, at: indexPath)
        case let .alias(viewModel):
            return aliasSettingsCell(with: viewModel.aliasName, at: indexPath)
        case let .emptyDataMessage(viewModel):
            return emptyDataMessageCell(for: viewModel, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func headerCell(
        with message: String,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AliasListSettingsHeaderCell.identifier,
            for: indexPath
        ) as? AliasListSettingsHeaderCell else {
            return UITableViewCell()
        }
        
        cell.setHeaderMessage(message)
        return cell
    }
    
    private func aliasSettingsCell(
        with aliasName: String,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AliasSettingsCell.identifier,
            for: indexPath
        ) as? AliasSettingsCell else {
            return UITableViewCell()
        }
        
        cell.setAliasName(aliasName)
        return cell
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
        
        cell.setViewModel(viewModel)
        return cell
    }
}

private extension AliasListSettingsViewController {
    func setUp() {
        configureSubviews()
        configureNavigationItem()
        configureTableView()
        configureStyling()
    }
    
    func configureSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureNavigationItem() {
        NavigationBarBuilder(
            style: .white,
            title: .tooltip(
                titleKey: localized("pl_blik_title_withoutCode"),
                type: .red,
                action: { [weak self] sender in
                    self?.showTooltip(from: sender)
                }
            )
        )
        .setLeftAction(.back(action: #selector(close)))
        .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureTableView() {
        tableView.register(AliasListSettingsHeaderCell.self, forCellReuseIdentifier: AliasListSettingsHeaderCell.identifier)
        tableView.register(AliasSettingsCell.self, forCellReuseIdentifier: AliasSettingsCell.identifier)
        tableView.register(EmptyDataMessageCell.self, forCellReuseIdentifier: EmptyDataMessageCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func showTooltip(from sender: UIView) {
        let navigationToolTip = NavigationToolTip()
        navigationToolTip.add(title: .plain(text: localized("pl_blik_title_withoutCode")))
        navigationToolTip.add(description: .plain(text: localized("pl_blik_text_tooltipWithoutCode")))
        navigationToolTip.show(in: self, from: sender)
    }
}
