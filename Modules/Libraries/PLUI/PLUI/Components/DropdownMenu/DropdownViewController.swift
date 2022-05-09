//
//  DropdownViewController.swift
//
//  Created by Piotr Mielcarzewicz on 24/06/2021.
//

import UIKit

public protocol DropdownPresenter {
    func present(items: [DropdownItem], in parent: UIViewController)
}

public final class DropdownViewController: UIViewController, DropdownPresenter {
    private let tableView = UITableView()
    private let dismissGestureLayer = UIView()
    private var items: [DropdownItem] = []
    private lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    private weak var parentController: UIViewController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateDropdownHeight()
    }
    
    public func present(items: [DropdownItem], in parent: UIViewController) {
        self.items = items
        self.parentController = parent
        configureSelfAsChild(in: parent)
        tableView.reloadData()
        updateDropdownHeight()
        animateDropdownPresentation()
    }
    
    private func setUp() {
        configureDismissGesture()
        configureSubviews()
        configureTableView()
        applyStyling()
    }
    
    private func configureSubviews() {
        view.addSubview(dismissGestureLayer)
        view.addSubview(tableView)
        dismissGestureLayer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissGestureLayer.topAnchor.constraint(equalTo: view.topAnchor),
            dismissGestureLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissGestureLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissGestureLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.86),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewHeightConstraint
        ])
    }
    
    private func configureSelfAsChild(in parent: UIViewController) {
        parent.view.addSubview(view)
        parent.addChild(self)
        didMove(toParent: parent)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.alpha = 0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.register(DropdownItemCell.self, forCellReuseIdentifier: DropdownItemCell.identifier)
    }
    
    private func applyStyling() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .white
        tableView.drawRoundedBorderAndShadow(
            with: .init(color: .lightSanGray, opacity: 0.5, radius: 4, withOffset: 0, heightOffset: 2),
            cornerRadius: 4,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
    }
    
    private func configureDismissGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissDropdown)
        )
        tapGesture.cancelsTouchesInView = false
        dismissGestureLayer.addGestureRecognizer(tapGesture)
    }
    
    private func animateDropdownPresentation() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 1
        }
    }
    
    @objc private func dismissDropdown() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
        } completion: { _ in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    private func updateDropdownHeight() {
        let dropdownItemsHeightSum = CGFloat(items.count) * Constants.itemHeight
        let maximumDropdownHeight = view.frame.height / 2
        tableViewHeightConstraint.constant = min(dropdownItemsHeightSum, maximumDropdownHeight)
    }
}

extension DropdownViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DropdownItemCell.identifier,
            for: indexPath
        ) as? DropdownItemCell else {
            return UITableViewCell()
        }
        
        cell.setViewModel(items[indexPath.row].name)
        return cell
    }
}

extension DropdownViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].action()
        dismissDropdown()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.itemHeight
    }
}

extension DropdownViewController {
    enum Constants {
        static var itemHeight: CGFloat {
            return 58
        }
    }
}
