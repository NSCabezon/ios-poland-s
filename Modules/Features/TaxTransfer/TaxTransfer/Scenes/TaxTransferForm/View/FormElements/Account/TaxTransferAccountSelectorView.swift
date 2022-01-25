//
//  TaxTransferAccountSelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 13/12/2021.
//

import PLUI

final class TaxTransferAccountSelectorView: UIView {
    private lazy var accountSection = getSectionContainer(with: accountView)
    private lazy var selectorSection = getSectionContainer(with: selectorView)
    private let accountView = SelectedAccountView()
    private let selectorView = TaxTransferElementSelectorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with viewModel: Selectable<TaxTransferFormViewModel.AccountViewModel>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(accountViewModel):
            showSelectedAccount(
                viewModel: accountViewModel,
                onTap: onTap
            )
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
}

private extension TaxTransferAccountSelectorView {
    func showSelectedAccount(
        viewModel: TaxTransferFormViewModel.AccountViewModel,
        onTap: @escaping () -> Void
    ) {
        selectorSection.isHidden = true
        accountSection.isHidden = false
        accountView.setViewModel(mapViewModels(from: viewModel))
        accountView.setChangeAction(onTap)
    }
    
    func showSelector(onTap: @escaping () -> Void) {
        accountSection.isHidden = true
        selectorSection.isHidden = false
        selectorView.configure(onTap: onTap)
    }
    
    func setUp() {
        configureSubviews()
        showSelector(onTap: {})
    }
    
    func configureSubviews() {
        [accountSection, selectorSection].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            accountSection.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            accountSection.bottomAnchor.constraint(equalTo: bottomAnchor),
            accountSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountSection.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectorSection.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            selectorSection.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectorSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorSection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getSectionContainer(with view: UIView) -> FormSectionContainer {
        return FormSectionContainer(
            containedView: view,
            sectionTitle: "#Konto, z którego robisz przelew"
        )
    }
    
    func mapViewModels(from viewModel: TaxTransferFormViewModel.AccountViewModel) -> [SelectableAccountViewModel] {
        let mappedViewModel = SelectableAccountViewModel(
            name: viewModel.accountName,
            accountNumber: viewModel.maskedAccountNumber,
            accountNumberUnformatted: viewModel.unformattedAccountNumber,
            availableFunds: viewModel.accountBalance,
            isSelected: true
        )
        
        if viewModel.isEditButtonEnabled {
            // There is additional dummy viewModel in order for `SelectedAccountView` to display edit button
            return [
                mappedViewModel,
                SelectableAccountViewModel(
                    name: "",
                    accountNumber: "",
                    accountNumberUnformatted: "",
                    availableFunds: "",
                    isSelected: false
                ),
            ]
        }
        
        return [mappedViewModel]
    }
}
