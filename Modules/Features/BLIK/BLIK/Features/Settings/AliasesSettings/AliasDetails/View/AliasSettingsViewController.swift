//
//  AliasSettingsViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//

import Commons
import UI

protocol AliasSettingsView: AnyObject {
    func setViewModel(_ viewModel: AliasSettingsViewModel)
}

final class AliasSettingsViewController: UIViewController {
    private let presenter: AliasSettingsPresenterProtocol
    private var viewModel: AliasSettingsViewModel
    private let header = AliasSettingsHeaderView()
    private let tableView = UITableView()
    
    init(presenter: AliasSettingsPresenterProtocol) {
        self.presenter = presenter
        self.viewModel = .init(aliasName: "", expirationDate: "", settingsOptions: [])
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

extension AliasSettingsViewController: AliasSettingsView {
    func setViewModel(_ viewModel: AliasSettingsViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.header.setViewModel(viewModel)
            self.tableView.reloadData()
        }
    }
}

extension AliasSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = viewModel.settingsOptions[indexPath.row]
        presenter.didSelectOption(selectedOption)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AliasSettingsOptionCell.identifier,
            for: indexPath
        ) as? AliasSettingsOptionCell else {
            return UITableViewCell()
        }
        
        let option = viewModel.settingsOptions[indexPath.row]
        cell.setOptionName(option.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

private extension AliasSettingsViewController {
    func setUp() {
        configureSubviews()
        configureNavigationItem()
        configureTableView()
        configureStyling()
    }
    
    func configureSubviews() {
        [header, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
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
        tableView.register(AliasSettingsOptionCell.self, forCellReuseIdentifier: AliasSettingsOptionCell.identifier)
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
