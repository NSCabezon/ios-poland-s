//
//  ChequesViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 24/06/2021.
//

import UI
import CoreFoundationLib

final class ChequesViewController: SegmentedPageViewController {
    private let dropdownPresenter: DropdownPresenter
    private let coordinator: ChequesCoordinator
    
    init(
        dropdownPresenter: DropdownPresenter,
        coordinator: ChequesCoordinator,
        activeChequesController: UIViewController,
        archivedChequesController: UIViewController
    ) {
        self.dropdownPresenter = dropdownPresenter
        self.coordinator = coordinator
        super.init(pagedControllers: [
            SegmentedPageViewController.PagedController(
                title: localized("pl_blik_button_activeCheque"),
                controller: activeChequesController
            ),
            SegmentedPageViewController.PagedController(
                title: localized("pl_blik_button_archiveCheque"),
                controller: archivedChequesController
            )
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_blikCheque")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
        let optionsButton = UIBarButtonItem(
            image: Images.options,
            style: .plain,
            target: self,
            action: #selector(didTapOptions)
        )
        optionsButton.imageInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 14
        )
        navigationItem.setRightBarButton(optionsButton, animated: true)
    }
    
    @objc func close() {
        coordinator.pop()
    }
    
    @objc private func didTapOptions() {
        let items = [
            DropdownItem(
                name: localized("pl_blik_label_passChequeChang"),
                action: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.coordinator.showChequePIN(didSetPin: { [weak self] in
                        self?.coordinator.pop()
                    })
                }
            )
        ]
        dropdownPresenter.present(
            items: items,
            in: self
        )
    }
}
