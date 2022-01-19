//
//  PhoneContactsView.swift
//  PhoneTopUp
//
//  Created by 188216 on 10/01/2022.
//

import UI
import PLUI
import Commons

protocol PhoneContactsViewProtocol: AnyObject {
    func showContactsPermissionsDeniedDialog()
    func reloadData()
}

final class PhoneContactsViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: PhoneContactsPresenterProtocol
    private let mainStackView = UIStackView()
    private let searchViewContainer = UIView()
    private let searchView = LisboaTextField()
    private let tableViewContainer = UIView()
    private let contactsTableView = UITableView()
    private let contactsEmptyView = ContactsEmptyView()
    private let navigationBarSeparator = UIView()
    private let bottomButtonView = BottomButtonView(style: .red)
    
    // MARK: Lifecycle
    
    init(presenter: PhoneContactsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        reloadData()
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
                             title: .title(key: localized("pl_topup_title_contacts")))
            .setLeftAction(.back(action: #selector(goBack)))
            .build(on: self, with: nil)
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(navigationBarSeparator)
        mainStackView.addArrangedSubview(searchViewContainer)
        mainStackView.addArrangedSubview(tableViewContainer)
        mainStackView.addArrangedSubview(bottomButtonView)
        
        searchViewContainer.addSubviewConstraintToEdges(searchView,
                                                        padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0))
        
        tableViewContainer.addSubviewConstraintToEdges(contactsTableView,
                                                       padding: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 0, right: 16.0))
        tableViewContainer.addSubview(contactsEmptyView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 0.0
        
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        contactsEmptyView.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            contactsEmptyView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor, constant: 16.0),
            contactsEmptyView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor, constant: 16.0),
            contactsEmptyView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor, constant: -16.0),
            searchView.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        
        navigationBarSeparator.backgroundColor = .lightSanGray
        
        contactsTableView.separatorStyle = .none
        
        contactsEmptyView.isHidden = true
        contactsEmptyView.setUp(with: .emptyContacts(textKey: "pl_topup_text_recipNoFound"))
        
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
        searchView.setClearAccessory(.clearDefault)

        searchView.setPlaceholder(localized("pl_topup_text_searchRecip"))
        searchView.updatableDelegate = self
        
        bottomButtonView.configure(title: localized("pl_topup_button_anothNumb")) { [weak self] in
            self?.presenter.didSelectClose()
        }
    }
    
    private func setUpTableView() {
        contactsTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        contactsTableView.register(MobileContactsTableHeaderView.self, forHeaderFooterViewReuseIdentifier: MobileContactsTableHeaderView.identifier)
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
}

extension PhoneContactsViewController: PhoneContactsViewProtocol {
    func showContactsPermissionsDeniedDialog() {
        let dialog = ContactsPermissionDeniedDialogBuilder().buildDialog()
        dialog.showIn(self)
    }
    
    func reloadData() {
        contactsEmptyView.isHidden = presenter.getNumberOfSections() > 0
        contactsTableView.reloadData()
    }
}

extension PhoneContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let contact = presenter.getContact(for: indexPath)
        cell.configure(with: contact)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfContacts(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MobileContactsTableHeaderView.identifier) as? MobileContactsTableHeaderView else {
            return nil
        }
        let sectionTitle = presenter.headerTitle(forSection: section)
        sectionHeaderView.configure(with: sectionTitle)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectContact(at: indexPath)
    }
}

extension PhoneContactsViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        let query = searchView.text ?? ""
        if query.isEmpty {
            contactsEmptyView.setUp(with: .emptyContacts(textKey: "pl_topup_text_recipNoFound"))
        } else {
            contactsEmptyView.setUp(with: .noSearchResult(query: query, textKey: "pl_topup_text_selectRecipNoFound"))
        }
        presenter.didUpdateQuery(to: query)
    }
}
