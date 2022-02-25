//
//  NotificationsFilterViewController.swift
//  Account
//
import UIKit
import WebKit
import UI
import PLUI
import SANPLLibrary
import CoreFoundationLib

protocol NotificationsFilterViewProtocol: AnyObject {
    func addFilters(_ filtersCategoriesTypes: [EnabledPushCategorie], _ filtersStatusesTypes: [NotificationStatus])
}

class NotificationsFilterViewController: UIViewController {
    private var selectedFilters = [EnabledPushCategorie]()
    private var selectedStatuses = [NotificationStatus]()
    private let presenter: NotificationsFilterPresenterProtocol
    private let scrollView = UIScrollView()
    private let setFilterButton = LisboaButton()
    private let clearFilterButton = LisboaButton()
    private let separator = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .mediumSkyGray
        return view
    }()
    private var checkBoxes = NotificationCheckBoxGroup(checkboxes: [])
    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.text = localized("pl_alerts_text_title_filtres")
        label.textColor = .lisboaGray
        label.font = .santander(family: .text, type: .bold, size: 20)
        return label
    }()
    
    init(presenter: NotificationsFilterPresenterProtocol,_ selectedFilters: [EnabledPushCategorie],_ selectedStatuses: [NotificationStatus]) {
        self.presenter = presenter
        self.selectedFilters = selectedFilters
        self.selectedStatuses = selectedStatuses
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension NotificationsFilterViewController: NotificationsFilterViewProtocol {
    func addFilters(_ filtersCategoriesTypes: [EnabledPushCategorie], _ filtersStatusesTypes: [NotificationStatus]) {
        var list = [UIView]()
        filtersCategoriesTypes.forEach({
            let checkBox = getCheckBox(with: $0.getLabel())
            checkBox.isSelected = self.selectedFilters.contains($0)
            list.append(checkBox)
        })
        list.append(separator)
        filtersStatusesTypes.forEach({
            let checkBox = getCheckBox(with: $0.getLabel())
            checkBox.isSelected = self.selectedStatuses.contains($0)
            list.append(checkBox)
        })
        checkBoxes = NotificationCheckBoxGroup(checkboxes: list)
        checkBoxes.delegate = self
        scrollView.addSubview(checkBoxes)
        
        self.checkBoxes.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBoxes.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            checkBoxes.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            checkBoxes.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            checkBoxes.topAnchor.constraint(equalTo: scrollView.topAnchor),
            checkBoxes.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @objc func close() {
        presenter.didSelectClose()
    }
    
    func setup() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareActions()
        prepareLayout()
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(setFilterButton)
        view.addSubview(clearFilterButton)
        view.addSubview(scrollView)
    }
    
    func getCheckBox(with text: String) -> GlobileCheckBox {
        let checkBox = GlobileCheckBox()
        checkBox.checkboxSize = 20
        checkBox.fontSize = 14
        checkBox.text = text
        checkBox.color = .red
        checkBox.isSelected = false
        return checkBox
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white, title: .tooltip(
            titleKey: "pl_alerts_title_notifications",
            type: .red,
            action: { [weak self] sender in
                self?.showGeneralTooltip(sender)
            }
        )).setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        clearFilterButton.configureAsWhiteButton()
        clearFilterButton.setTitle(localized("pl_alerts_button_cleanFilters"), for: .normal)
        
        setFilterButton.configureAsRedButton()
        setFilterButton.setTitle(localized("pl_alerts_button_applyFilters"), for: .normal)
    }
    
    func prepareActions() {
        clearFilterButton.addAction { [weak self] in
            self?.checkBoxes.checkboxes.forEach({ v in
                if let checkBox = v as? GlobileCheckBox {
                    checkBox.isSelected = false
                }
            })
            self?.selectedFilters.removeAll()
            self?.selectedStatuses.removeAll()
        }
        
        setFilterButton.addAction { [weak self] in
            self?.presenter.setFilters(self?.selectedFilters ?? [], self?.selectedStatuses ?? [])
        }
    }
    
    func prepareLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        let buttonWidth = (self.view.frame.width - (16 * 3)) / 2
        self.clearFilterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearFilterButton.heightAnchor.constraint(equalToConstant: 48),
            clearFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clearFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clearFilterButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        self.setFilterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setFilterButton.heightAnchor.constraint(equalToConstant: 48),
            setFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            setFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            setFilterButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: clearFilterButton.topAnchor),
        ])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func showGeneralTooltip(_ sender: UIView) {
        let navigationToolTip = NavigationToolTip()
        navigationToolTip.add(title: localized("pl_alerts_title_tooltipAlerts"))
        navigationToolTip.add(description: localized("pl_alerts_text_tooltipAlerts"))
        navigationToolTip.show(in: self, from: sender)
        UIAccessibility.post(notification: .announcement, argument: localized("pl_alerts_text_tooltipAlerts").text)
    }
}

extension NotificationsFilterViewController: NotificationsCheckboxGroupDelegate {
    func didSelect(checkbox: GlobileCheckBox){
        guard let text = checkbox.text else { return }
        let filter = EnabledPushCategorie.allCases.first { pushCategorie in
            pushCategorie.getLabel() == text
        }
        if let filter = filter {
            selectedFilters.append(filter)
        }else {
            let filter = NotificationStatus.allCases.first { status in
                status.getLabel() == text
            }
            if let filter = filter {
                selectedStatuses.append(filter)
            }
        }
    }
    
    func didDeselect(checkbox: GlobileCheckBox){
        guard let text = checkbox.text else { return }
        if let pushCategorie = EnabledPushCategorie.allCases.first(where: { pushCategorie in
            pushCategorie.getLabel() == text
        }) {
            selectedFilters.removeAll(where: {$0 == pushCategorie})
        } else {
            let filter = NotificationStatus.allCases.first { status in
                status.getLabel() == text
            }
            selectedStatuses.removeAll(where: {$0 == filter})
        }
    }
}
