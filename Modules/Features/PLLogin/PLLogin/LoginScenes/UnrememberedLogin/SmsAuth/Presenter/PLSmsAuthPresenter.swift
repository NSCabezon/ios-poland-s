//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import Security

protocol PLSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLSmsAuthViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func authenticate(smsCode: String)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

final class PLSmsAuthPresenter {
    weak var view: PLSmsAuthViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func viewDidLoad() {
        self.doAuthenticateInit()
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func authenticate(smsCode: String) {
        self.doAuthenticate(smscode: smsCode)
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }
}

extension PLSmsAuthPresenter: PLLoginPresenterLayerProtocol {
    func handle(event: LoginProcessLayerEvent) {
        // TODO
    }

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
private extension  PLSmsAuthPresenter {
    var coordinator: PLSmsAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLSmsAuthCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {
        self.loginManager?.doAuthenticateInit(userId: loginConfiguration.userIdentifier, challenge: loginConfiguration.challenge)
    }

    func doAuthenticate(smscode: String) {
        let secondFactorData = SecondFactorDataAuthenticationEntity(challenge: loginConfiguration.challenge, value: smscode)
        guard let password = loginConfiguration.password else {
            // TODO: generate error, password can't be empty
            return
        }
        let encrytionKey = EncryptionKeyEntity(modulus: "", exponent: "") // TODO: Get public key from repository

        self.loginManager?.doAuthenticate(encryptedPassword: self.encryptPassword(password: password, encryptionKey: encrytionKey),
                                          userId: loginConfiguration.userIdentifier,
                                          secondFactorData: secondFactorData)
    }

    func encryptPassword(password: String, encryptionKey: EncryptionKeyEntity) throws -> String {
        
        var encryptedPassword = ""

      
        return encryptedPassword

    }



//    public String encryptPassword(String password, EncryptionKey encryptionKey) {
//
//            String encryptedPassword = null;
//
//            try {
//                BigInteger modulus = new BigInteger(encryptionKey.getModulus(), 16); //encryptionKey.getModulus() received from /api/as/pub_key
//                BigInteger exponent = new BigInteger(encryptionKey.getExponent(), 16); //encryptionKey.getExponent() received from /api/as/pub_key
//                RSAPublicKeySpec spec = new RSAPublicKeySpec(modulus, exponent);
//
//                KeyFactory factory = KeyFactory.getInstance("RSA");
//                PublicKey publicKey = factory.generatePublic(spec);
//                Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
//                cipher.init(Cipher.ENCRYPT_MODE, publicKey);
//
//                byte[] cipherText = cipher.doFinal(password.getBytes());
//                encryptedPassword = DatatypeConverter.printHexBinary(cipherText).toLowerCase();
//            } catch (Exception e) {
//                throw new RuntimeException(e);
//            }
//            return encryptedPassword;
//        }
}
