//
//  URLSessionPinningDelegate.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

final class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    private let isTrustInvalidCertificateEnabled: Bool
    private let paths = Bundle.main.paths(forResourcesOfType: "cer", inDirectory: nil)
    
    init(isTrustInvalidCertificateEnabled: Bool) {
        self.isTrustInvalidCertificateEnabled = isTrustInvalidCertificateEnabled
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard self.isTrustInvalidCertificateEnabled else {
            completionHandler(.useCredential, nil)
            return
        }
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let server = self.createServerCertificateData(serverCertificate)
        for path in self.paths {
            if let certificate = NSData(contentsOfFile: path), server.isEqual(to: certificate as Data) {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}

private extension URLSessionPinningDelegate {
    func createServerCertificateData(_ certificate: SecCertificate) -> NSData {
        let serverCertificateData = SecCertificateCopyData(certificate)
        let data = CFDataGetBytePtr(serverCertificateData)
        let size = CFDataGetLength(serverCertificateData)
        return NSData(bytes: data, length: size)
    }
}
