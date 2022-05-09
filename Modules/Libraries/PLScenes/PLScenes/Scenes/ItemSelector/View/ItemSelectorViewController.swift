//
//  ItemSelectorViewController.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol ItemSelectorView: AnyObject,
                           ConfirmationDialogPresentable {
    
}

final class ItemSelectorViewController<Item: SelectableItem>: UIViewController,
                                                              UITableViewDelegate,
                                                              UITableViewDataSource,
                                                              ItemSelectorView {
    private let presenter: ItemSelectorPresenter<Item>
    
    private let searchView = ItemSearchView()
    private let tableView = UITableView()
    private lazy var searchZeroHeightConstraint = searchView.heightAnchor.constraint(
        equalToConstant: 0
    )
    
    private var viewModel: ItemSelectorViewModel<Item> {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(presenter: ItemSelectorPresenter<Item>) {
        self.presenter = presenter
        self.viewModel = .sections([])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel = presenter.getViewModel(filteredBy: .unfiltered)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel {
        case let .sections(sectionViewModels):
            return sectionViewModels.count
        case .emptySearchResultMessage:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel {
        case .sections:
            return 70
        case .emptySearchResultMessage:
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel {
        case let .sections(sectionViewModels):
            guard let section = sectionViewModels[safe: section] else {
                assertionFailure("Section shouldn't be empty here!")
                return 0
            }
            return section.itemViewModels.count
        case .emptySearchResultMessage:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel {
        case let .sections(sectionViewModels):
            guard let section = sectionViewModels[safe: section] else {
                assertionFailure("Section shouldn't be empty here!")
                return nil
            }
            let view = ItemSelectorSectionHeader()
            view.configure(with: section.sectionTitle)
            return view
        case .emptySearchResultMessage:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel {
        case let .sections(sectionViewModels):
            return getItemCell(for: sectionViewModels, at: indexPath)
        case let .emptySearchResultMessage(viewModel):
            return getEmptySearchResultCell(for: viewModel, at: indexPath)
        }
    }
    
    private func getItemCell(for sectionViewModels: [SelectableItemSectionViewModel<Item>], at indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(
            withIdentifier: ItemSelectorCell.identifier,
            for: indexPath
        ) as? ItemSelectorCell
        
        guard
            let cell = dequeuedCell,
            let section = sectionViewModels[safe: indexPath.section],
            let viewModel = section.itemViewModels[safe: indexPath.row]
        else {
            assertionFailure("ItemSelectorCell should be dequeued!")
            return UITableViewCell()
        }
        
        cell.setUp(
            title: viewModel.itemName,
            isSelected: viewModel.isSelected,
            onTap: { [weak self] in
                self?.presenter.didSelectItem(viewModel.item)
            }
        )
        
        return cell
    }
    
    private func getEmptySearchResultCell(
        for viewModel: ItemSelectorViewModel<Item>.EmptySearchResultMessageViewModel,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmptySearchResultCell.identifier,
            for: indexPath
        ) as? EmptySearchResultCell else {
            assertionFailure("EmptySearchResultCell should be dequeued!")
            return UITableViewCell()
        }
        
        cell.configure(
            titleMessageText: viewModel.titleMessage,
            searchPhraseText: viewModel.searchPhrase
        )
        
        return cell
    }
    
    private func setUp() {
        configureNavigationItem()
        configureLayout()
        configureSearch()
        configureTableView()
        configureStyling()
        configureKeyboardDismissGesture(shouldCancelTouchesInView: false)
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: presenter.getNavigationTitle()))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions(.close(action: .selector(#selector(close))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc private func back() {
        presenter.didTapBack()
    }
    
    @objc private func close() {
        presenter.didTapClose()
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureSearch() {
        searchZeroHeightConstraint.priority = .required
        searchView.setUpdateDelegate(self)
        switch presenter.getSearchMode() {
        case let .enabled(configuration):
            searchView.setPlaceholderText(configuration.searchBarPlaceholderText)
            searchZeroHeightConstraint.isActive = false
        case .disabled:
            searchZeroHeightConstraint.isActive = true
            
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(
            ItemSelectorCell.self,
            forCellReuseIdentifier: ItemSelectorCell.identifier
        )
        tableView.register(
            EmptySearchResultCell.self,
            forCellReuseIdentifier: EmptySearchResultCell.identifier
        )
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
             tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func configureLayout() {
        [searchView, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ItemSelectorViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        let searchText = searchView.getSearchText()
        
        if searchText.isEmpty {
            viewModel = presenter.getViewModel(filteredBy: .unfiltered)
        } else {
            viewModel = presenter.getViewModel(filteredBy: .text(searchText))
        }
    }
}
