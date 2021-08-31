//
//  PLDeviceDataGenerateDataUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 31/8/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift

final class PLDeviceDataGenerateDataUseCase: UseCase<Void, PLDeviceDataGenerateDataUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLDeviceDataGenerateDataUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let useCaseOutput = PLDeviceDataGenerateDataUseCaseOutput(deviceData: self.generateData())
        return .ok(useCaseOutput)
    }

    private lazy var deviceTimeString: String = {
        let dateFormatterISO8601 = DateFormatter()
        dateFormatterISO8601.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatterISO8601.string(from: self.currentDate)
    }()

    private lazy var parametersTimeString: String = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df.string(from: self.currentDate)
    }()

    private lazy var currentDate: Date = {
        return Date()
    }()
}

private extension PLDeviceDataGenerateDataUseCase {

    enum Constants {
        static let oneApp = "OneApp"
        static let manufacturer = "Apple"
    }

    func generateData() -> TrustedDeviceConfiguration.DeviceData {

        let model = UIDevice.current.getDeviceName()
        let brand = Constants.manufacturer
        let deviceId = PLLoginTrustedDeviceHelpers.secureRandom(bytesNumber: 9)?.toHexString() ?? ""
        let appId = Constants.oneApp + deviceId
        let manufacturer = Constants.manufacturer
        let dateString = self.parametersTimeString
        let parameters = "<\(dateString)><AppId><\(appId)><deviceId><\(deviceId)><manufacturer><\(manufacturer)><model><\(model)>"
        let deviceTime = self.deviceTimeString

        let deviceData = TrustedDeviceConfiguration.DeviceData(manufacturer: manufacturer,
                                                               model: model,
                                                               brand: brand,
                                                               appId: appId,
                                                               deviceId: deviceId,
                                                               deviceTime: deviceTime,
                                                               parameters: parameters)
        return deviceData
    }
}

struct PLDeviceDataGenerateDataUseCaseOutput {
    let deviceData: TrustedDeviceConfiguration.DeviceData
}
