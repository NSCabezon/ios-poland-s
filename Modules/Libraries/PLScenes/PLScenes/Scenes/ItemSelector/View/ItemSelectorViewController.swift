//
//  ItemSelectorViewController.swift
//  PLUI
//
//  Created by 185167 on 04/02/2022.
//

import CoreFoundationLib
import UI

final class ItemSelectorViewController<Item>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let coordinator: ItemSelectorCoordinator<Item>
    private let viewModel: ItemSelectorViewModel<Item>
    private let headerLabel = UILabel()
    private let tableView = UITableView()
    
    init(
        coordinator: ItemSelectorCoordinator<Item>,
        viewModel: ItemSelectorViewModel<Item>
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(
            withIdentifier: ItemSelectorCell.identifier,
            for: indexPath
        ) as? ItemSelectorCell
        
        guard
            let cell = dequeuedCell,
            let viewModel = viewModel.itemViewModels[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.setUp(
            title: viewModel.itemName,
            isSelected: viewModel.isSelected,
            onTap: { [weak self] in
                self?.coordinator.handleItemSelection(viewModel.item)
            }
        )
        
        return cell
    }
    
    private func setUp() {
        configureNavigationItem()
        configureHeaderLabel()
        configureStyling()
        configureSubviews()
        configureTableView()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: viewModel.navigationTitle))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions(.close(action: .selector(#selector(close))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc private func back() {
        coordinator.back()
    }
    
    @objc private func close() {
        coordinator.close()
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureHeaderLabel() {
        headerLabel.font = .santander(family: .text, type: .regular, size: 16)
        headerLabel.textColor = .greyishBrown
        headerLabel.text = viewModel.headerText
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(ItemSelectorCell.self, forCellReuseIdentifier: ItemSelectorCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureSubviews() {
        [headerLabel, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
