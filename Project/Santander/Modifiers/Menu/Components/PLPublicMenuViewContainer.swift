//
//  PLPublicMenuViewContainer.swift
//  Santander
//
//  Created by crodrigueza on 21/9/21.
//

import Menu
import Commons

final class PLPublicMenuViewContainer {
    private let resolver: DependenciesResolver
    private let viewComponent: PLPublicMenuViewComponents
    private let mainStackView = UIStackView()
    
    init(resolver: DependenciesResolver) {
        self.resolver = resolver
        self.viewComponent = PLPublicMenuViewComponents(resolver: resolver)
    }
    
    func createView(data: PublicMenuViewComponentsProtocol?) -> UIView {
        self.viewComponent.dataComponent = data
        self.configureStackView()
        self.createFirstRow()
        return self.mainStackView
    }
}

private extension PLPublicMenuViewContainer {
    func createFirstRow() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.heightAnchor.constraint(equalToConstant: 128.0).isActive = true
        let exampleView = self.viewComponent.setExampleView()
        stackView.addArrangedSubview(exampleView)
        self.mainStackView.addArrangedSubview(stackView)
    }
    
    func configureStackView() {
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.axis = .vertical
        self.mainStackView.spacing = 8
        self.mainStackView.distribution = .fill
    }
}

extension PLPublicMenuViewContainer: PublicMenuViewContainerProtocol { }
