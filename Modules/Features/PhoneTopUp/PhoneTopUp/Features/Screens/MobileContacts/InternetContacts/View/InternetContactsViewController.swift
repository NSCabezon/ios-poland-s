//
//  InternetContactsViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/12/2021.
//

import UI
import PLUI
import Commons

protocol InternetContactsViewProtocol: AnyObject {
    func showContactsPermissionsDeniedDialog()
}

final class InternetContactsViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: InternetContactsPresenterProtocol
    private let mainStackView = UIStackView()
    private let tableViewContainer = UIStackView()
    private let contactsLabel = UILabel()
    private let contactsTableView = UITableView()
    private let navigationBarSeparator = UIView()
    private let bottomButtonView = BottomButtonView(style: .red)
    
    // MARK: Lifecycle
    
    init(presenter: InternetContactsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        contactsTableView.reloadData()
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
                             title: .title(key: localized("pl_topup_title_phoneNumRecip")))
            .setLeftAction(.back(action: #selector(goBack)))
            .build(on: self, with: nil)
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(navigationBarSeparator)
        mainStackView.addArrangedSubview(tableViewContainer)
        mainStackView.addArrangedSubview(bottomButtonView)
        
        tableViewContainer.addArrangedSubview(contactsLabel)
        tableViewContainer.addArrangedSubview(contactsTableView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 0.0
        
        tableViewContainer.axis = .vertical
        tableViewContainer.spacing = 16.0
        tableViewContainer.isLayoutMarginsRelativeArrangement = true
        tableViewContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16.0, bottom: 0, trailing: 16.0)
        
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarSeparator.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        navigationBarSeparator.backgroundColor = .lightSanGray
        contactsLabel.text = localized("pl_topup_text_recipSanInt")
        contactsLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        contactsLabel.textColor = .lisboaGray
        contactsTableView.separatorStyle = .none
        bottomButtonView.configure(title: localized("pl_topup_button_phonebook")) { [weak self] in
            self?.presenter.didTouchPhoneContactsButton()
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

extension InternetContactsViewController: InternetContactsViewProtocol {
    func showContactsPermissionsDeniedDialog() {
        let dialog = ContactsPermissionDeniedDialogBuilder().buildDialog()
        dialog.showIn(self)
    }
}

extension InternetContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
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
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MobileContactsTableHeaderView.identifier) as! MobileContactsTableHeaderView
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
