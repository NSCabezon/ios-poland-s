//
//  TaxAuthoritySelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

import CoreFoundationLib
import PLScenes
import UI
import PLUI
import PLCommons

protocol TaxAuthoritySelectorCoordinatorProtocol: ModuleCoordinator {}

final class TaxAuthoritySelectorCoordinator: TaxAuthoritySelectorCoordinatorProtocol  {
    weak var navigationController: UINavigationController?
    
    private let dependenciesEngine: DependenciesDefault
    private let taxAuthorities: [TaxAuthority]
    private let selectedTaxAuthority: SelectedTaxAuthority?
    private let taxSymbols: [TaxSymbol]
    private let onSelect: (SelectedTaxAuthority) -> Void
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        taxAuthorities: [TaxAuthority],
        selectedTaxAuthority: SelectedTaxAuthority?,
        taxSymbols: [TaxSymbol],
        onSelect: @escaping (SelectedTaxAuthority) -> Void
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.taxAuthorities = taxAuthorities
        self.selectedTaxAuthority = selectedTaxAuthority
        self.taxSymbols = taxSymbols
        self.onSelect = onSelect
        setUpDependencies()
    }
    
    func start() {
        if taxAuthorities.isEmpty {
            showTaxAuthorityForm()
        } else {
            showTaxAuthorityList()
        }
    }
}

private extension TaxAuthoritySelectorCoordinator {
    func showTaxAuthorityList() {
        let viewModelMapper = SelectableTaxAuthorityViewModelMapper()
        let itemsViewModels = taxAuthorities.map {
            viewModelMapper.map(
                $0,
                selectedTaxAuthority: selectedTaxAuthority?.selectedPredefinedTaxAuthority
            )
        }
        let selectedItemViewModel: SelectableTaxAuthorityViewModel? = {
            guard let taxAuthority = selectedTaxAuthority?.selectedPredefinedTaxAuthority else { return nil }
            return viewModelMapper.map(taxAuthority, selectedTaxAuthority: taxAuthority)
        }()
        let configuration = TaxTransferParticipantConfiguration<SelectableTaxAuthorityViewModel>(
            shouldBackAfterSelectItem: true,
            taxItemSelectorType: .payee,
            items: itemsViewModels,
            selectedItem: selectedItemViewModel
        )
        let taxItemSelectorCoordinator = TaxTransferParticipantSelectorCoordinator<SelectableTaxAuthorityViewModel>(
            configuration: configuration,
            itemSelectionHandler: handleTaxAuthoritySelection,
            buttonActionHandler: showTaxAuthorityForm,
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        taxItemSelectorCoordinator.start()
    }
    
    func handleTaxAuthoritySelection(
        with taxAuthorityViewModel: SelectableTaxAuthorityViewModel,
        in presenter: (LoaderPresentable & ConfirmationDialogPresentable)
    ) {
        presenter.showLoader()
        TaxAccountValidator(dependenciesResolver: dependenciesEngine).validateAccount(
            withNumber: taxAuthorityViewModel.taxAuthority.accountNumber,
            onValidResult: { [weak self] associatedTaxFormType in
                presenter.hideLoader(completion: {
                    self?.showTaxSymbolSelector(
                        taxAuthority: taxAuthorityViewModel.taxAuthority,
                        associatedTaxFormType: associatedTaxFormType
                    )
                })
            },
            onInvalidResult: { [weak self] in
                presenter.hideLoader(completion: {
                    self?.showInvalidTaxAccountDialog(in: presenter)
                })
            },
            onError: { [weak self] _ in
                presenter.hideLoader(completion: {
                    self?.showInvalidTaxAccountDialog(in: presenter)
                })
            }
        )
    }
    
    func showTaxSymbolSelector(
        taxAuthority: TaxAuthority,
        associatedTaxFormType: Int
    ) {
        let filteredTaxSymbols = taxSymbols.filter { $0.symbolType == associatedTaxFormType }
        let coordinator = TaxSymbolSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            shouldPopControllerAfterSelection: false,
            taxSymbols: filteredTaxSymbols,
            selectedTaxSymbol: selectedTaxAuthority?.selectedTaxSymbol,
            onSelection: { [weak self] taxSymbol in
                let selectedTaxAuthority = SelectedTaxAuthority.SelectedPredefinedTaxAuthorityData(
                    taxAuthority: taxAuthority,
                    taxSymbol: taxSymbol
                )
                self?.onSelect(.predefinedTaxAuthority(selectedTaxAuthority))
            }
        )
        coordinator.start()
    }
    
    func showTaxAuthorityForm() {
        if let selectedTaxAuthority = selectedTaxAuthority {
            showTaxAuthorityForm(withContext: .preselectedTaxAuthority(selectedTaxAuthority))
        } else {
            showTaxAuthorityForm(withContext: .unselectedTaxAuthority)
        }
    }
    
    func showTaxAuthorityForm(withContext context: AddTaxAuthorityEntryPointContext) {
        let coordinator = AddTaxAuthorityCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            entryPointContext: context,
            taxSymbols: taxSymbols,
            onSelect: onSelect
        )
        coordinator.start()
    }
    
    // TODO:- Replace with generic LisboaDialog wrapper implemented in other PR
    func showInvalidTaxAccountDialog(in presenter: ConfirmationDialogPresentable) {
        let image = LisboaDialogImageViewItem(image: PLAssets.image(named: "info_blueGreen"), size: (50, 50))
        let buttonTitle = LocalizedStylableText(text: localized("generic_link_ok"), styles: nil)
        
        let items: [LisboaDialogItem] = [
            .margin(25),
            .image(image),
            .margin(12),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_taxTransfer_informationTitle_authorityNoAccNum"),
                    font: .santander(family: .micro, type: .bold, size: 28),
                    color: .black,
                    alignament: .center,
                    margins: (((0, 0)))
                )
            ),
            .margin(12),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_taxTransfer_information_invalidAccNum"),
                    font: .santander(family: .micro, type: .regular, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: (24, 24)
                )
            ),
            .margin(24),
            .verticalAction(
                VerticalLisboaDialogAction(
                    title: buttonTitle,
                    type: .red,
                    margins: (16, 16),
                    action: {}
                )
            ),
            .margin(16)
        ]
        
        let dialog = LisboaDialog(items: items, closeButtonAvailable: false)
        presenter.showDialog(dialog)
    }
    
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxAccountMapping.self) { _ in
            return TaxAccountMapper(
                dateFormatter: PLTimeFormat.yyyyMMdd.createDateFormatter()
            )
        }
        
        dependenciesEngine.register(for: GetTaxAccountsUseCaseProtocol.self) { resolver in
            return GetTaxAccountsUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxAccountTypeRecognizing.self) { _ in
            return TaxAccountTypeRecognizer(
                identifierValidator: TaxIdentifierValidator()
            )
        }
    }
}
