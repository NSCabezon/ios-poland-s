//
//  SecIdentity+PEMFormat.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 22/10/21.
//


extension SecIdentity
{
    public func PEMFormattedCertificate() -> String {
        guard let certificate = self.certificate?.data.base64EncodedString() else { return "" }
        let certificatePEM = certificate.addPEMformat(header: String.PEMFormats.certificate.header, footer: String.PEMFormats.certificate.footer)
        return certificatePEM
    }

    public func PEMFormattedPrivateKey() -> String {
        var error: Unmanaged<CFError>? = nil
        guard let privateKey = self.privateKey else { return "" }
        let privateKeyDataB64 = (SecKeyCopyExternalRepresentation(privateKey, &error) as Data?)?.base64EncodedString()
        let pemformatted = privateKeyDataB64?.addPEMformat(header: String.PEMFormats.privateKey.header, footer: String.PEMFormats.privateKey.footer) ?? ""
        return pemformatted
    }

    public func PEMFormattedPublicKey() -> String {
        var error: Unmanaged<CFError>? = nil
        guard let publicKey = self.certificate?.publicKey else { return "" }
        let publicKeyB64 = (SecKeyCopyExternalRepresentation(publicKey, &error) as Data?)?.base64EncodedString()
        let pemformatted = publicKeyB64?.addPEMformat(header: String.PEMFormats.publicKey.header, footer: String.PEMFormats.publicKey.footer) ?? ""
        return pemformatted
    }
}

private extension String {

    enum PEMFormats {
        static let newLine = "\n"
        enum certificate {
            static let header = "-----BEGIN CERTIFICATE-----\n"
            static let footer = "\n-----END CERTIFICATE-----\n"
        }
        enum privateKey {
            static let header = "-----BEGIN RSA PRIVATE KEY-----\n"
            static let footer = "\n-----END RSA PRIVATE KEY-----"
        }
        enum publicKey {
            static let header = "-----BEGIN PUBLIC KEY-----\n"
            static let footer = "\n-----END PUBLIC KEY-----"
        }
    }

    func addPEMformat(header: String, footer: String) -> String {
        let pemFormatted = header + self.unfoldSubSequences(limitedTo: 64).joined(separator: "\n") + footer
        return pemFormatted
    }
}

private extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}

