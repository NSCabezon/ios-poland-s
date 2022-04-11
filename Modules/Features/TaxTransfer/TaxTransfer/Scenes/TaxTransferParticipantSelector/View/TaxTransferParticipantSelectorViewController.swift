//
//  TaxItemSelectorViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 10/02/2022.
//

import PLUI
import UI
import PLCommons
import CoreFoundationLib
import PLScenes

protocol TaxItemSelectorView: AnyObject {
    func didTapButton()
}

final class TaxTransferParticipantSelectorViewController<Item: SelectableItem>: UIViewController,
                                                                 UITableViewDataSource,
                                                                 UITableViewDelegate,
                                                                 LoaderPresentable,
                                                                 ConfirmationDialogPresentable {
    weak var delegate: TaxItemSelectorView?
    private let tableView = UITableView()
    private let button = LisboaButton()
    private let infoLabel = UILabel()
    
    private let taxItemSelectorType: TaxTransferParticipantSelectorType
    private var viewModel: TaxTransferParticipantSelectorViewModel<Item>
    private let coordinator: TaxTransferParticipantSelectorCoordinator<Item>
    private let confirmationDialogFactory: ConfirmationDialogProducing
    
    init(taxItemSelectorType: TaxTransferParticipantSelectorType,
         viewModel: TaxTransferParticipantSelectorViewModel<Item>,
         coordinator: TaxTransferParticipantSelectorCoordinator<Item>,
         confirmationDialogFactory: ConfirmationDialogProducing) {
        self.taxItemSelectorType = taxItemSelectorType
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.confirmationDialogFactory = confirmationDialogFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
        tableView.reloadData()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func set(viewModel: TaxTransferParticipantSelectorViewModel<Item>) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch taxItemSelectorType {
        case .payee:
            return getPayeeCell(at: indexPath)
        case .payer:
            return getPayerCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch taxItemSelectorType {
        case .payee:
            return UITableView.automaticDimension
        case .payer:
            return 110
        }
    }
    
    private func getPayeeCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectablePayeeCell.identifier,
            for: indexPath
        )
        
        guard
            let payeeCell = cell as? SelectablePayeeCell,
            let item = viewModel.viewModels[safe: indexPath.row]?.item,
            let viewModel = item as? SelectableTaxAuthorityViewModel
        else {
            return UITableViewCell()
        }
        
        payeeCell.configure(
            viewModel: viewModel,
            onTap: { [weak self] in
                self?.coordinator.handleItemSelection(item)
            }
        )
        return payeeCell
    }
    
    private func getPayerCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectablePayerCell.identifier,
            for: indexPath
        ) as? SelectablePayerCell,
        let taxPayerViewModel = viewModel.viewModels[safe: indexPath.row],
        let isSelected = viewModel.viewModels[safe: indexPath.row]?.isSelected,
        let viewModel = taxPayerViewModel.item as? TaxTransferFormViewModel.TaxPayerViewModel else {
            return UITableViewCell()
        }
        
        cell.setUp(
            with: viewModel,
            isSelected: isSelected,
            onTap: { [weak self] in
                self?.coordinator.handleItemSelection(taxPayerViewModel.item)
            }
        )
        return cell
    }
    
    private func setUp() {
        configureStyling()
        configureButton()
        configureSubviews()
        configureInfoLabel()
        configureTableView()
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: taxItemSelectorType.title))
            .setLeftAction(.back(action: #selector(back)))
            .setRightActions(.close(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        switch taxItemSelectorType {
        case .payer:
            tableView.register(SelectablePayerCell.self, forCellReuseIdentifier: SelectablePayerCell.identifier)
        case .payee:
            tableView.register(SelectablePayeeCell.self, forCellReuseIdentifier: SelectablePayeeCell.identifier)
        }
    }
    
    private func configureSubviews() {
        [infoLabel, tableView, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10),
            
            button.heightAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -23),
        ])
    }
    
    private func configureButton() {
        button.setTitle(localized(taxItemSelectorType.buttonTitle), for: .normal)
        button.configureAsWhiteButton()
        button.addAction { [weak self] in
            self?.delegate?.didTapButton()
        }
    }
    
    private func configureInfoLabel() {
        infoLabel.font = .santander(family: .text, type: .regular, size: 16)
        infoLabel.textColor = .greyishBrown
        infoLabel.text = taxItemSelectorType.info
    }

    @objc private func back() {
        coordinator.back()
    }
    
    @objc private func close() {
        let closeConfirmationDialog = confirmationDialogFactory.create(
            message: localized("#Czy na pewno chcesz zakończyć"),
            confirmAction: { [weak self] in
                self?.coordinator.close()
            },
            declineAction: {}
        )
        showDialog(closeConfirmationDialog)
    }
}
