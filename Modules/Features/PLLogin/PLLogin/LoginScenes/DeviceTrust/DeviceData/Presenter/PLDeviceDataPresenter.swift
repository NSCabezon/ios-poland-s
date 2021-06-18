//
//  PLDeviceDataPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import DomainCommon
import Commons
import Models

protocol PLDeviceDataPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLDeviceDataViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
}

final class PLDeviceDataPresenter {
    weak var view: PLDeviceDataViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
}

extension PLDeviceDataPresenter: PLDeviceDataPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }

    func viewWillAppear() {
        // TODO
    }
}
