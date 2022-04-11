//
//  OperatorSelectionCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/01/2022.
//

import CoreFoundationLib
import PLCommons
import UI

protocol OperatorSelectionCoordinatorProtocol: AnyObject {
    func back()
    func didSelectOperator(_ gsmOperator: Operator)
}

protocol OperatorSelectorDelegate: AnyObject {
    func didSelectOperator(_ gsmOperator: Operator)
}

final class OperatorSelectionCoordinator: ModuleCoordinator {
    // MARK: Properties
    
    var navigationController: UINavigationController?
    private weak var delegate: OperatorSelectorDelegate?
    private let dependenciesEngine: DependenciesDefault
    private lazy var operatorSelectionController = dependenciesEngine.resolve(for: OperatorSelectionViewController.self)
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                delegate: OperatorSelectorDelegate?,
                navigationController: UINavigationController?,
                operators: [Operator],
                selectedOperatorId: Int?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.delegate = delegate
        self.setUpDependencies(operators: operators, selectedOperatorId: selectedOperatorId)
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies(operators: [Operator], selectedOperatorId: Int?) {

        dependenciesEngine.register(for: OperatorSelectionCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: OperatorSelectionPresenterProtocol.self) { resolver in
            return OperatorSelectionPresenter(dependenciesResolver: resolver,
                                              operators: operators,
                                              selectedOperatorId: selectedOperatorId)
        }
        
        dependenciesEngine.register(for: OperatorSelectionViewController.self) { resolver in
            let presenter = resolver.resolve(for: OperatorSelectionPresenterProtocol.self)
            let controller = OperatorSelectionViewController(presenter: presenter)
            presenter.view = controller
            return controller
        }
    }
    
    // MARK: Methods
    
    public func start() {
        navigationController?.pushViewController(operatorSelectionController, animated: true)
    }
}

extension OperatorSelectionCoordinator: OperatorSelectionCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectOperator(_ gsmOperator: Operator) {
        delegate?.didSelectOperator(gsmOperator)
    }
}
