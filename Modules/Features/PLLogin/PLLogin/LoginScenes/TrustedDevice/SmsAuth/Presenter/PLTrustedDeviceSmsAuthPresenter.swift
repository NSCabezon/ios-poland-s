//
//  PLTrustedDeviceSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//
import Models
import Commons
import PLCommons

protocol PLTrustedDeviceSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSmsAuthViewProtocol? { get set }
    func viewDidLoad()
    func goBack()
    func authenticate(smsCode: String)
}

final class PLTrustedDeviceSmsAuthPresenter: PLTrustedDeviceSmsAuthPresenterProtocol {
    
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLTrustedDeviceSmsAuthViewProtocol?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
    }
    
    func goBack() {
        // TODO: implement navigate back to device trust pin
    }
    
    func authenticate(smsCode: String) {
        
    }
    
}
