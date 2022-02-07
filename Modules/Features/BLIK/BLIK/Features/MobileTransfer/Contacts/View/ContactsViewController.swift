import UI
import Commons
import Foundation
import PLUI
import PLCommons
import IQKeyboardManagerSwift

protocol ContactsViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable {
    func setViewModels(_ viewModels: [ContactViewModel])
    func showEmptyView(_ show: Bool)
}

final class ContactsViewController: UIViewController, ContactsViewProtocol {
    
    private let presenter: ContactsPresenterProtocol
    
    private let tableView = UITableView()
    private let searchView = LisboaTextField()
    private let bottomView = BottomButtonView()
    private lazy var emptyView = ContactsEmptyView()

    private var viewModels: [ContactViewModel] = []
    private var filteredContacts: [MobileContact] = []
    private let viewModelMapper = ContactViewModelMapper()
    private var isSearching = false
    
    init(presenter: ContactsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.addNavigationBarShadow()
    }
    
    func setViewModels(_ viewModels: [ContactViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = viewModels
            self.tableView.reloadData()
        }
    }
    
    func showEmptyView(_ show: Bool) {
        searchView.isHidden = show

        if show {
            view.addSubview(emptyView)
            emptyView.setUp(with: .emptyContacts(textKey: "pl_blik_text_emptyContancs"))

            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}

extension ContactsViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        guard let text = searchView.text, !text.isEmpty else {
            showAllResults()
            return
        }
        
        let query = text.lowercased()
        let filteredRows = viewModels
            .flatMap{ $0.contacts }
            .filter {
                $0.fullName.lowercased().contains(query)
                    || $0.phoneNumber.lowercased().contains(query)
            }
        
        filteredContacts = filteredRows
        showNoResultsView(filteredContacts.isEmpty, query: text)
        isSearching = true
        tableView.reloadData()
    }
}

private extension ContactsViewController {
    @objc
    func close() {
        presenter.didSelectClose()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareLayout()
        configureTableView()
        configureKeyboardDismissGesture()
    }
    
    func showAllResults() {
        isSearching = false
        showNoResultsView(false)
        tableView.reloadData()
    }

    func addSubviews() {
        view.addSubview(searchView)
        view.addSubview(tableView)
        view.addSubview(bottomView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_contacts")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        searchView.isHidden = true
        view.backgroundColor = .white
    
        bottomView.configure(title: localized("pl_blik_button_diffNumber"), action: { [weak self] in
            self?.presenter.showTransferForm()
        })
        let formatter = UIFormattedCustomTextField()
        formatter.setAllowOnlyCharacters(CharacterSet(charactersIn: localized("digits_operative") + "żŻźŹćĆńŃłŁśŚóÓ"))
        searchView.setEditingStyle(.writable(configuration: .init(type: .floatingTitle,
                                                                  formatter: formatter,
                                                                  disabledActions: [],
                                                                  keyboardReturnAction: nil,
                                                                  textFieldDelegate: nil,
                                                                  textfieldCustomizationBlock: nil)))
        searchView.setStyle(LisboaTextFieldStyle.default)
        searchView.setRightAccessory(.image("icnSearch", action: {}))

        searchView.setPlaceholder(localized("pl_blik_text_searchRecip"))
        searchView.updatableDelegate = self
        
    }
    
    
    func prepareLayout() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchView.heightAnchor.constraint(equalToConstant: 48),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(LetterHeaderView.self, forHeaderFooterViewReuseIdentifier: LetterHeaderView.identifier)
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
    }
    
    func showNoResultsView(_ show: Bool, query: String = "") {
        if show {
            view.addSubview(emptyView)
            emptyView.setUp(with: .noSearchResult(query: query, textKey: "pl_blik_text_noFoundRecip"))

            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
                emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            emptyView.removeFromSuperview()
        }
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        isSearching ? 1 : viewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredContacts.count : viewModels[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isSearching else { return UIView() }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LetterHeaderView.identifier) as?  LetterHeaderView else {
            return UIView()
        }
        header.setText(viewModels[section].letter)
        tableView.removeUnnecessaryHeaderTopPadding()
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier,
                                                       for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let contact = isSearching ? filteredContacts[indexPath.row] : viewModels[indexPath.section].contacts[indexPath.row]
        cell.setContact(contact, backgroundColor: contact.color)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = isSearching ? filteredContacts[indexPath.row] : viewModels[indexPath.section].contacts[indexPath.row]
        presenter.didSelectContact(contact)
    }
}
