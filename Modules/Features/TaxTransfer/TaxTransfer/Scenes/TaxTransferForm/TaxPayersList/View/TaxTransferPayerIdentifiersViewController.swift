//
//  TaxTransferPayerIdentifiersViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 17/01/2022.
//

import UI
import CoreFoundationLib

final class TaxTransferPayerIdentifiersViewController: UIViewController {
    private let identifiersTableView = UITableView()
    private let infoLabel = UILabel()

    private let presenter: TaxTransferPayerIdentifiersPresenterProtocol
    private let viewModel: TaxTransferPayerIdentifiersViewModelProtocol
    
    init(presenter: TaxTransferPayerIdentifiersPresenterProtocol,
         viewModel: TaxTransferPayerIdentifiersViewModelProtocol) {
        self.presenter = presenter
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
    }
    
    private func setUp() {
        configureStyling()
        configureSubviews()
        configureTableView()
        configureInfoLabel()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: "pl_toolbar_title_chooseID"))
            .setLeftAction(.back(action: #selector(back)))
            .setRightActions(.close(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureInfoLabel() {
        infoLabel.font = .santander(family: .text, type: .regular, size: 16)
        infoLabel.textColor = .greyishBrown
        infoLabel.text = localized("pl_taxTransfer_text_chooseID")
    }
    
    private func configureTableView() {
        identifiersTableView.delegate = self
        identifiersTableView.dataSource = self
        identifiersTableView.register(SelectablePayerIdentifierCell.self, forCellReuseIdentifier: SelectablePayerIdentifierCell.identifier)
        
        identifiersTableView.separatorStyle = .none
        identifiersTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureSubviews() {
        [infoLabel, identifiersTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            identifiersTableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            identifiersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            identifiersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            identifiersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func back() {
        presenter.didPressBack()
    }
    
    @objc private func close() {
        presenter.didPressClose()
    }
}

extension TaxTransferPayerIdentifiersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectIdenfier(index: indexPath.row)
        
        guard let selectedInfo = viewModel.selectedInfo else { return }
        
        presenter.didSelectTaxPayerIdentifier(taxPayer: viewModel.taxPayer, selectedPayerInfo: selectedInfo)
    }
}

extension TaxTransferPayerIdentifiersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectablePayerIdentifierCell.identifier, for: indexPath) as? SelectablePayerIdentifierCell,
              let identifier = viewModel.identifier(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.setUp(with: identifier)
        
        return cell
    }
}
