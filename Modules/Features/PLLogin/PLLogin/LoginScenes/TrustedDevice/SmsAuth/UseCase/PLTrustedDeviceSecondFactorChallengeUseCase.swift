//
//  PLTrustedDeviceSecondFactorChanllengeUseCase.swift
//  PLLogin
//

import Commons
import PLCommons
import DomainCommon
import SANPLLibrary

final class PLTrustedDeviceSecondFactorChallengeUseCase: UseCase<PLTrustedDeviceSecondFactorChallengeInput, PLTrustedDeviceSecondFactorChallengeOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {

    public override func executeUseCase(requestValues: PLTrustedDeviceSecondFactorChallengeInput) throws -> UseCaseResponse<PLTrustedDeviceSecondFactorChallengeOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        let challenge = PLTrustedDeviceSecondFactorChallengeOutput(challenge: self.calculateSecondFactorSmsChallenge(input: requestValues))
        return .ok(challenge)
    }
}

// MARK: I/O types definition
struct PLTrustedDeviceSecondFactorChallengeInput {
    let userId: Int
    let configuration: TrustedDeviceConfiguration

    struct PLTrustedDeviceSecondFactorChallengeToken {
        let id: Int
        let timestamp: Int
    }
}

struct PLTrustedDeviceSecondFactorChallengeOutput {
    let challenge: String?
}


extension PLTrustedDeviceSecondFactorChallengeUseCase {

    func calculateSecondFactorSmsChallenge(input: PLTrustedDeviceSecondFactorChallengeInput) -> String? {

        var challenge: String = ""
        
        guard let ivrCode = input.configuration.ivrOutputCode,
              let trustedDeviceId = input.configuration.trustedDevice?.trustedDeviceId,
              let deviceTime = input.configuration.trustedDevice?.trustedDeviceTimestamp,
              let tokens = input.configuration.tokens else { return challenge }

        let challengeTokens = tokens.compactMap {
            return PLTrustedDeviceSecondFactorChallengeInput.PLTrustedDeviceSecondFactorChallengeToken(id: $0.id,
                                                                                                       timestamp: $0.timestamp)
        }

        challengeTokens.forEach({ token in
            challenge = challenge + getChallengeFor(tokenId: token.id,
                                                    tokenTimeStamp: token.timestamp,
                                                    id: input.userId) + "|"
        })
        challenge = challenge + getChallengeFor(tokenId: trustedDeviceId,
                                                tokenTimeStamp: deviceTime,
                                                id: input.userId)
        challenge = String(format: "%@|%d", challenge, ivrCode)
        return hashChallenge(challenge)
    }

    func getChallengeFor(tokenId: Int, tokenTimeStamp: Int , id: Int) -> String {
        return(String(format: "%08d-%010d-%010d",id, tokenId, tokenTimeStamp))
    }

    func hashChallenge(_ challenge: String) -> String {
        var challengeNumber:Int64 = 0
        var blockChallengeNumber:Int64 = 0
        let challengeUC:String = challenge.uppercased()
        var j:Int = 0
        for i in 0...(challengeUC.count-1) {
            let c = challengeUC[challengeUC.index(challengeUC.startIndex, offsetBy: i)]
            if c.isNumber || c.isLetter {
                if (j % 8) == 0 {
                    challengeNumber += blockChallengeNumber
                    blockChallengeNumber = 0
                }
                blockChallengeNumber *= 10
                if c.isNumber, let asciiVal = c.asciiValue {
                    let zero = Int64(("0" as Character).asciiValue ?? 0)
                    blockChallengeNumber += Int64(asciiVal) - zero
                } else if let asciiVal = c.asciiValue {
                    let capitalA = Int64(("A" as Character).asciiValue ?? 0)
                    blockChallengeNumber += (Int64(asciiVal) - capitalA) % 10
                }
                j += 1
            }
        }
        challengeNumber += blockChallengeNumber
        challengeNumber &= 4294967295
        return String(format: "%08d", challengeNumber % 100000000)
    }
}
