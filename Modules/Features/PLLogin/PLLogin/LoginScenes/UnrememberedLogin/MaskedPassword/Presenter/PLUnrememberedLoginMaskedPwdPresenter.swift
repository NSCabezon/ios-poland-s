//
//  PLUnrememberedLoginMaskedPwdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import PLUI

protocol PLUnrememberedLoginMaskedPwdPresenterProtocol: MenuTextWrapperProtocol, PLUIInputCodeViewDelegate {
    var view: PLUnrememberedLoginMaskedPwdViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String, magic: String, remember: Bool)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
    func requestedPositions() -> [Int]
}

final class PLUnrememberedLoginMaskedPwdPresenter {
    weak var view: PLUnrememberedLoginMaskedPwdViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLUnrememberedLoginMaskedPwdPresenterProtocol {
    func viewDidLoad() {
        // TODO
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func login(identification: String, magic: String, remember: Bool) {
        // TODO
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }

    // Returns [Int] with the positions requested for the masked password
    func requestedPositions() -> [Int] {

        let num = 1048575 // TODO: Get this number from the response of the API
        let binaryString = String(num, radix: 2)
        var pos = 0
        let requestedPositions: [Int] = binaryString.compactMap {
            let value = Int(String($0)) ?? 0
            pos += 1
            return value == 1 ? pos : nil
        }
        return requestedPositions
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLLoginPresenterLayerProtocol {

    func handle(event: SessionProcessEvent) {
        // TODO
    }
    func willStartSession() {
        // TODO
    }

    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginMaskedPwdPresenter {
    var coordinator: PLLoginCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
    }

}

extension  PLUnrememberedLoginMaskedPwdPresenter: PLUIInputCodeViewDelegate {

    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {
        guard string.count == 1,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(UnicodeScalar(character)) == true else {
            return false
        }
        return true
    }

    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, didDelete position: NSInteger) {
    }
}
