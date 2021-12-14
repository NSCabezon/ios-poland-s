//
//  PLGetGenericErrorDialogDataUseCase.swift
//  Santander
//
//  Created by Rodrigo Jurado on 29/11/21.
//

import CoreFoundationLib
import Commons
import Models
import UI

final class PLGetGenericErrorDialogDataUseCase: UseCase<Void, GetGenericErrorDialogDataUseCaseOkOutput, StringErrorOutput> {

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetGenericErrorDialogDataUseCaseOkOutput, StringErrorOutput> {
        guard let webUrl = URL(string: "https://www.santander.pl/") else {
            return .error(StringErrorOutput(nil))
        }
        let phone = "61 811 9999"
        return .ok(GetGenericErrorDialogDataUseCaseOkOutput(webUrl: webUrl, phone: phone))
    }
}

extension PLGetGenericErrorDialogDataUseCase: GetGenericErrorDialogDataUseCaseProtocol { }
