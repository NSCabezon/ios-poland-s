//
//  AccountSelectorViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 29/07/2021.
//

import UI
import PLUI

public protocol AccountSelectorViewProtocol: AnyObject,
                                      LoaderPresentable,
                                      ErrorPresentable,
                                      ConfirmationDialogPresentable {
    func setViewModels(_ viewModels: [SelectableAccountViewModel])
}

public final class AccountSelectorViewController: UIViewController {
    private let footerTitle = UILabel()
    private let tableView = UITableView()
    private let presenter: AccountSelectorPresenterProtocol
    private var viewModels: [SelectableAccountViewModel] = []
    private let screenLocationConfiguration: ScreenLocationConfiguration
    
    public init(
        presenter: AccountSelectorPresenterProtocol,
        screenLocationConfiguration: ScreenLocationConfiguration
    ) {
        self.presenter = presenter
        self.screenLocationConfiguration = screenLocationConfiguration
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
}

extension AccountSelectorViewController: AccountSelectorViewProtocol {
    public func setViewModels(_ viewModels: [SelectableAccountViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = viewModels
            self.tableView.reloadData()
            self.footerTitle.isHidden = false
        }
    }
}

extension AccountSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectableAccountCell.identifier,
            for: indexPath
        ) as? SelectableAccountCell else {
            return UITableViewCell()
        }
        
        cell.setViewModel(viewModels[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAccount(at: indexPath.row)
    }
}

private extension AccountSelectorViewController {
    func setUp() {
        configureLayout()
        configureNavigationItem()
        configureStyling()
        configureFooterTitle()
        configureTableView()
    }
    
    private func configureNavigationItem() {
        let navBuilder = NavigationBarBuilder(style: .white, title: .title(key: "pl_blik_title_selectAccount"))
            .setLeftAction(.back(action: #selector(close)))
        
        if screenLocationConfiguration.showRightNavigationAction {
            navBuilder.setRightActions(.close(action: #selector(closeProcess)))
        }
        
        navBuilder.build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    @objc func closeProcess() {
        presenter.didCloseProcess()
    }
    
    func configureLayout() {
        view.addSubview(footerTitle)
        view.addSubview(tableView)
        
        footerTitle.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            footerTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: footerTitle.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        footerTitle.isHidden = true
        footerTitle.textColor = .lisboaGray
        footerTitle.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
    
    func configureFooterTitle() {
        footerTitle.text = screenLocationConfiguration.title
    }
    
    func configureTableView() {
        tableView.register(
            SelectableAccountCell.self,
            forCellReuseIdentifier: SelectableAccountCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
}
