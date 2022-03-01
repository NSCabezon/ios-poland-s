//
//  ChequeDetailsViewController.swift
//  BLIK
//
//  Created by 186491 on 16/06/2021.
//

import UIKit
import UI
import PLUI
import PLCommons

protocol ChequeDetailsViewProtocol: AnyObject, SnackbarPresentable, LoaderPresentable, ErrorPresentable {
    func displayErrorMessage(_ message: String)
    func showSuccessNotification(_ message: String)
}

final class ChequeDetailsViewController: UIViewController, ErrorPresentable, SnackbarPresentable {
    private lazy var contentView = makeChequeDetailsView()
    private let presenter: ChequeDetailsPresenterProtocol
    private var viewModel: ChequeDetailsViewModel?
    
    init(
        presenter: ChequeDetailsPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(completion: { [weak self] viewModel in
            self?.setViewModel(viewModel)
        })
    }
    
    private func setViewModel(_ viewModel: ChequeDetailsViewModel) {
        self.viewModel = viewModel
        contentView.footerView.isHidden = !viewModel.shouldShowFooter
        contentView.tableView.reloadData()
        configureNavigationItem(withTitle: viewModel.chequeName)
    }
    
    private func configureNavigationItem(withTitle title: String) {
        NavigationBarBuilder(style: .white, title: .title(key: title))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
}
    
extension ChequeDetailsViewController: ChequeDetailsViewProtocol {
    func displayErrorMessage(_ message: String) {
        showErrorMessage(message, onConfirm: nil)
    }
    
    func showSuccessNotification(_ message: String) {
        showSnackbar(message: message, type: .success)
    }
}

extension ChequeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChequeDetailsCell.identifier,
                for: indexPath
            ) as? ChequeDetailsCell,
            let viewModel = viewModel?.items[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsCell.root.id + ".\(indexPath.row)"
        cell.setViewModel(viewModel)
        return cell
    }
}
    
private extension ChequeDetailsViewController {
    func makeChequeDetailsView() -> ChequeDetailsView {
        let view = ChequeDetailsView()
        view.tableView.dataSource = self
        view.footerView.removeButtonTap = { [weak self] in
            self?.presenter.didPressRemove()
        }
        view.footerView.sendButtonTap = { [weak self] in
            self?.presenter.didPressSend()
        }
        return view
    }
}
