//
//  PLEcommerceManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez Mesa on 10/5/21.
//

import SANLegacyLibrary

final class PLEcommerceManagerAdapter {}

extension PLEcommerceManagerAdapter: BSANEcommerceManager {

        func getOperationData(shortUrl: String) throws -> BSANResponse<EcommerceOperationDataDTO> {
            return BSANResponse()
        }

        func getLastOperationShortUrl(documentType: String, documentNumber: String, tokenPush: String) throws -> BSANResponse<EcommerceLastOperationShortUrlDTO> {
            return BSANResponse()
        }

        func confirmWithAccessKey(shortUrl: String, key: String) throws -> BSANResponse<Void> {
            return BSANResponse()
        }

        func confirmWithFingerPrint(input: EcommerceConfirmWithFingerPrintInputParams) throws -> BSANResponse<Void> {
            return BSANResponse()
        }
    }
