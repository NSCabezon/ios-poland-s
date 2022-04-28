//
//  OperatorSelectionViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/01/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol OperatorSelectionViewProtocol: AnyObject, ConfirmationDialogPresentable {
}

final class OperatorSelectionViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: OperatorSelectionPresenterProtocol
    private let mainStackView = UIStackView()
    private let tableViewContainer = UIStackView()
    private let titleLabel = UILabel()
    private let operatorsTableView = UITableView()
    
    // MARK: Lifecycle
    
    init(presenter: OperatorSelectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
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
        setUpTableView()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_topup_title_selectProvider")))
            .setLeftAction(.back(action: .selector(#selector(goBack))))
            .setRightActions(.close(action: .selector(#selector(close))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(tableViewContainer)
        
        tableViewContainer.addArrangedSubview(titleLabel)
        tableViewContainer.addArrangedSubview(operatorsTableView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 0.0
        
        tableViewContainer.axis = .vertical
        tableViewContainer.spacing = 16.0
        tableViewContainer.isLayoutMarginsRelativeArrangement = true
        tableViewContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16.0, bottom: 0, trailing: 16.0)
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        titleLabel.text = localized("pl_topup_title_selectProviderDesc")
        titleLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        titleLabel.textColor = .lisboaGray
        operatorsTableView.separatorStyle = .none
    }
    
    private func setUpTableView() {
        operatorsTableView.register(OperatorSelectionTableViewCell.self,
                                   forCellReuseIdentifier: OperatorSelectionTableViewCell.identifier)
        operatorsTableView.delegate = self
        operatorsTableView.dataSource = self
    }
    
    // MARK: Actions
    
    @objc
    private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc
    private func close() {
        presenter.didSelectClose()
    }
}

extension OperatorSelectionViewController: OperatorSelectionViewProtocol {
}

extension OperatorSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OperatorSelectionTableViewCell.identifier, for: indexPath) as? OperatorSelectionTableViewCell else {
            return UITableViewCell()
        }
        let cellModel = presenter.cellModel(for: indexPath.row)
        cell.configure(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCell(at: indexPath.row)
    }
}
