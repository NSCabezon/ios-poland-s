//
//  PLPublicMenuHelpCenterCoordinator.swift
//  PLHelpCenter
//
//  Created by 188454 on 22/02/2022.
//
import UI
import CoreFoundationLib

public final class PLPublicMenuHelpCenterCoordinator: BindableCoordinator {
    private let dependenciesResolver: DependenciesResolver
    public weak var navigationController: UINavigationController?
    public var onFinish: (() -> Void)?
    public var childCoordinators: [Coordinator] = []
    public var dataBinding: DataBinding = DataBindingObject()
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func start() {
        dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
    }
}
