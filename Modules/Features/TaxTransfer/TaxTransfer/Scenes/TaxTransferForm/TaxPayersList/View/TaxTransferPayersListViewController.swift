//
//  TaxTransferPayersListViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 16/12/2021.
//

import UI
import PLUI
import Commons

protocol TaxTransferPayersListView: AnyObject,
                                    ConfirmationDialogPresentable,
                                    LoaderPresentable,
                                    ErrorPresentable {

    func set(taxPayers: [TaxPayer])
    func set(selectedTaxPayer: TaxPayer?)
}

final class TaxTransferPayersListViewController: UIViewController {
    private let presenter: TaxTransferPayersListPresenterProtocol
    private let viewModel: TaxTransferPayersListViewModelProtocol
    
    private let payersTableView = UITableView()
    private let choosePayerButton = LisboaButton()
    private let infoLabel = UILabel()
    
    init(presenter: TaxTransferPayersListPresenterProtocol,
         viewModel: TaxTransferPayersListViewModelProtocol) {
        self.presenter = presenter
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
    }
    
    private func setUp() {
        configureStyling()
        configureButton()
        configureSubviews()
        configureInfoLabel()
        configureTableView()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: "pl_toolbar_title_Payee"))
            .setLeftAction(.back(action: #selector(back)))
            .setRightActions(.close(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureInfoLabel() {
        infoLabel.font = .santander(family: .text, type: .regular, size: 16)
        infoLabel.textColor = .greyishBrown
        infoLabel.text = localized("pl_taxTransfer_text_payeesList")
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureButton() {
        choosePayerButton.setTitle(localized("pl_taxTransfer_button_choosePayee"), for: .normal)
        choosePayerButton.configureAsWhiteButton()
    }
    
    private func configureTableView() {
        payersTableView.delegate = self
        payersTableView.dataSource = self
        payersTableView.register(SelectablePayerCell.self, forCellReuseIdentifier: SelectablePayerCell.identifier)
        payersTableView.separatorStyle = .none
        payersTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureSubviews() {
        [infoLabel, payersTableView, choosePayerButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            payersTableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            payersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            payersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            payersTableView.bottomAnchor.constraint(equalTo: choosePayerButton.topAnchor, constant: -10),
            
            choosePayerButton.heightAnchor.constraint(equalToConstant: 48),
            choosePayerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            choosePayerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            choosePayerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -23),
        ])
    }
    
    @objc private func back() {
        presenter.didPressBack()
    }
    
    @objc private func close() {
        presenter.didPressClose()
    }
}

extension TaxTransferPayersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectablePayerCell.identifier, for: indexPath) as? SelectablePayerCell,
              let taxPayerViewModel = viewModel.payer(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        
        cell.setUp(with: taxPayerViewModel, isSelected: viewModel.isSelected(index: indexPath.row))
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
}

extension TaxTransferPayersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPayer(index: indexPath.row)
        payersTableView.reloadData()
        
        guard let selectedTaxPayer = viewModel.currentTaxPayer else { return }
        presenter.didSelectTaxPayer(selectedTaxPayer, selectedPayerInfo: viewModel.selectedInfo)
    }
}

extension TaxTransferPayersListViewController: TaxTransferPayersListView {
    func set(taxPayers: [TaxPayer]) {
        viewModel.set(taxPayers: taxPayers)
        payersTableView.reloadData()
    }
    
    func set(selectedTaxPayer: TaxPayer?) {
        guard let selectedTaxPayer = selectedTaxPayer else { return }
        viewModel.set(selectedTaxPayer: selectedTaxPayer)
    }
}
