//
//  ItemSelectorViewController.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

import UI
import CoreFoundationLib

final class ItemSelectorViewController<Item: SelectableItem>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let presenter: ItemSelectorPresenter<Item>
    
    private let searchView = ItemSearchView()
    private let tableView = UITableView()
    private lazy var searchZeroHeightConstraint = searchView.heightAnchor.constraint(
        equalToConstant: 0
    )
    
    private var sectionViewModels: [SelectableItemSectionViewModel<Item>] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(presenter: ItemSelectorPresenter<Item>) {
        self.presenter = presenter
        self.sectionViewModels = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        sectionViewModels = presenter.getViewModels(filteredBy: .unfiltered)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionViewModels[safe: section] else {
            assertionFailure("Section shouldn't be empty here!")
            return 0
        }
        return section.itemViewModels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = sectionViewModels[safe: section] else {
            assertionFailure("Section shouldn't be empty here!")
            return nil
        }
        let view = ItemSelectorSectionHeader()
        view.configure(with: section.sectionTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(
            withIdentifier: ItemSelectorCell.identifier,
            for: indexPath
        ) as? ItemSelectorCell
        
        guard
            let cell = dequeuedCell,
            let section = sectionViewModels[safe: indexPath.section],
            let viewModel = section.itemViewModels[safe: indexPath.row]
        else {
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
    
    private func setUp() {
        configureNavigationItem()
        configureLayout()
        configureSearchView()
        configureTableView()
        configureStyling()
        configureKeyboardDismissGesture()
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
    
    private func configureSearchView() {
        searchZeroHeightConstraint.priority = .required
        searchZeroHeightConstraint.isActive = presenter.shouldDisableSearch()
        searchView.setUpdateDelegate(self)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(
            ItemSelectorCell.self,
            forCellReuseIdentifier: ItemSelectorCell.identifier
        )
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
            sectionViewModels = presenter.getViewModels(filteredBy: .unfiltered)
        } else {
            sectionViewModels = presenter.getViewModels(filteredBy: .text(searchText))
        }
    }
}
