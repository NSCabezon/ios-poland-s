//
//  PLApplePayEnrollmentManager.swift
//  Santander
//
//  Created by 185998 on 16/02/2022.
//

import Cards
import SANLegacyLibrary
import CoreFoundationLib
import RetailLegacy
import PassKit
import PLLegacyAdapter
import SANPLLibrary

protocol PLApplePayEnrollmentManagerProtocol {
    func enroll(virtualPan: String,
                cardholderName: String)
}

public extension PKPassLibrary {

    func containsActivatedPaymentPass(primaryAccountNumberSuffix: String) -> Bool {
        func paymentPasses() -> [PKPaymentPass] {
            var paymentPasses = [PKPaymentPass]()
            paymentPasses.append(contentsOf: passes(of: .payment).compactMap({ $0.paymentPass }))
            paymentPasses.append(contentsOf: remotePaymentPasses())
            return paymentPasses
        }
        return paymentPasses().contains(where: { $0.activationState == .activated && $0.primaryAccountNumberSuffix == primaryAccountNumberSuffix })
    }
}

class PLApplePayEnrollmentManager: NSObject {
    private var virtualPan: String?
    var addToApplePayConfirmationUseCase: PLAddToApplePayConfirmationUseCase?
    var dependenciesResolver: DependenciesResolver?
    var navigationController: UINavigationController?

    override init() {}

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController? = nil) {
        self.dependenciesResolver = dependenciesResolver
        self.navigationController = navigationController
        self.addToApplePayConfirmationUseCase = PLAddToApplePayConfirmationUseCase(dependenciesResolver: dependenciesResolver)
    }

    private func handleSuccess() {}

    private func handleError(_ error: ApplePayError) {}
}

extension PLApplePayEnrollmentManager: PLApplePayEnrollmentManagerProtocol {
    func enroll(virtualPan: String, cardholderName: String) {

        self.virtualPan = virtualPan

        let configuration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2)
        configuration?.cardholderName = cardholderName
        configuration?.primaryAccountSuffix = virtualPan.substring(ofLast: 4)

        guard
            let paymentConfiguration = configuration,
            let paymentPassViewController = PKAddPaymentPassViewController(requestConfiguration: paymentConfiguration, delegate: self)
        else {
            self.handleError(.notAvailable)
            return
        }
        navigationController?.present(paymentPassViewController, animated: true, completion: nil)
    }
}

extension PLApplePayEnrollmentManager: PKAddPaymentPassViewControllerDelegate {

    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController,
                                      generateRequestWithCertificateChain certificates: [Data],
                                      nonce: Data,
                                      nonceSignature: Data,
                                      completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void) {
        guard
            let virtualPan = virtualPan,
            let dependenciesResolver = self.dependenciesResolver,
            let addToApplePayConfirmationUseCase = self.addToApplePayConfirmationUseCase
        else {
            return
        }

        let useCase = addToApplePayConfirmationUseCase.setRequestValues(requestValues: PLAddToApplePayConfirmationUseCaseInput(virtualPan: virtualPan,
                                                                                                                               publicCertificates: certificates,
                                                                                                                               nonce: nonce,
                                                                                                                               nonceSignature: nonceSignature))

        UseCaseWrapper(
            with: useCase,
            useCaseHandler: dependenciesResolver.resolve(for: UseCaseHandler.self),
            onSuccess: { result in
                let request = PKAddPaymentPassRequest()

                if let tavData = Data(base64Encoded: result.tav),
                   let activationDataBase64 = String(data: tavData, encoding: .utf8) {
                    request.activationData = Data(base64Encoded: activationDataBase64)
                }

                if let encryptedPassData = Data(base64Encoded: result.encryptedPassData),
                   let encryptedPassHex = String(data: encryptedPassData, encoding: .utf8) {
                    request.encryptedPassData = Data(hex: encryptedPassHex)
                }

                if let ephemeralPublicKey = Data(base64Encoded: result.ephemeralPublicKey),
                   let ephemeralPublicKeyHex = String(data: ephemeralPublicKey, encoding: .utf8) {
                    request.ephemeralPublicKey = Data(hex: ephemeralPublicKeyHex)
                }

                handler(request)
            },
            onError: { [weak self] error in

                controller.dismiss(animated: true) { [weak self] in
                    self?.handleError(ApplePayError.description(error.getErrorDesc()))
                }
            }
        )
    }

    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController,
                                      didFinishAdding pass: PKPaymentPass?,
                                      error: Error?) {
        controller.dismiss(animated: true) { [weak self] in
            if let error = error {
                if let paymentPassError = (error as? PKAddPaymentPassError), paymentPassError == .userCancelled {
                    return
                }
                self?.handleError(ApplePayError.description(error.localizedDescription))
                return
            }
            guard pass != nil else {
                self?.handleError(ApplePayError.unknown)
                return
            }

            self?.handleSuccess()
        }
    }
}
