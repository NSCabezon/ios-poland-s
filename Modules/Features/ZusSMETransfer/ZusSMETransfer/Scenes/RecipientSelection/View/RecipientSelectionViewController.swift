import UI
import PLUI
import CoreFoundationLib

protocol RecipientSelectionViewProtocol: AnyObject,
                                         LoaderPresentable,
                                         ErrorPresentable,
                                         ConfirmationDialogPresentable {
    func setViewModel(_ viewModel: RecipientSelectionViewModel)
}

final class RecipientSelectionViewController: UIViewController {
    private let presenter: RecipientSelectionPresenterProtocol
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let mainStackView = UIStackView()
    private let headerViewContainer = UIStackView()
    private let headerLabel = UILabel()
    private let tableView = UITableView()
    private var viewModel: RecipientSelectionViewModel?
    
    init(
        presenter: RecipientSelectionPresenterProtocol,
        confirmationDialogFactory: ConfirmationDialogProducing
    ) {
        self.presenter = presenter
        self.confirmationDialogFactory = confirmationDialogFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
        
    private func setUp() {
        prepareNavigationBar()
        addSubviews()
        setUpLayout()
        configureViews()
        setUpTableView()
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("pl_recipients_toolbar")
            )
        )
        .setLeftAction(.back(action: .closure(goBack)))
        .setRightActions(.close(action: .closure(closeProcess)))
        .build(on: self, with: nil)
        
        navigationController?.addNavigationBarShadow()
    }
     
    private func addSubviews() {
        view.addSubview(mainStackView)
        [headerViewContainer, tableView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        headerViewContainer.addArrangedSubview(headerLabel)
    }
    
    private func setUpLayout() {
        headerLabel.isHidden = true
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        headerViewContainer.axis = .vertical
        headerViewContainer.spacing = 0
        headerViewContainer.isLayoutMarginsRelativeArrangement = true
        headerViewContainer.layoutMargins = .init(top: 16, left: 18, bottom: 0, right: 0)
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        headerLabel.text = localized("pl_zusTransfer_text_recipSanInt")
        headerLabel.font = .santander(family: .micro, type: .regular, size: 14)
        headerLabel.textColor = .greyishBrown
        tableView.separatorStyle = .none
    }
    
    private func setUpTableView() {
        tableView.register(
            RecipientTableViewCell.self,
            forCellReuseIdentifier: RecipientTableViewCell.identifier
        )
        tableView.register(
            EmptyTableViewCell.self,
            forCellReuseIdentifier: EmptyTableViewCell.identifier
        )
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func closeProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.presenter.didSelectCloseProcess()
        } declineAction: {}
        showDialog(dialog)
    }
}

extension RecipientSelectionViewController: RecipientSelectionViewProtocol {
    func setViewModel(_ viewModel: RecipientSelectionViewModel) {
        self.viewModel = viewModel
        headerLabel.isHidden = viewModel.isRecipientListEmpty
        tableView.reloadData()
        tableView.isScrollEnabled = !viewModel.isRecipientListEmpty
    }
}

extension RecipientSelectionViewController: UITableViewDataSource, UITableViewDelegate {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModelTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModelType = viewModel?.cellViewModelTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch cellViewModelType {
        case let .recipient(viewModel):
            return recipientCell(with: viewModel, at: indexPath)
        case let .empty(viewModel):
            return emptyCell(for: viewModel, at: indexPath)
        }
    }
    
    private func recipientCell(
        with viewModel: RecipientCellViewModel,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipientTableViewCell.identifier,
            for: indexPath
        ) as? RecipientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel)
        return cell
    }
    
    private func emptyCell(
        for viewModel: EmptyCellViewModel,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmptyTableViewCell.identifier,
            for: indexPath
        ) as? EmptyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCell(at: indexPath.row)
    }
}
