import SANPLLibrary
import CoreFoundationLib
import CoreDomain
import PLCommons

final class PLTransfersManagerSuccessMock: PLTransfersManagerProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getTransactionParameters(type: PLDomesticTransactionParametersType?) -> TransactionParameters? {
        nil
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError> {
        fatalError()
    }
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<CheckInternalAccountRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError> {
        let jsonData = """
        {
           "customerAddressData":{
              "customerName":"",
              "city":"",
              "street":"",
              "zipCode":"",
              "baseAddress":""
           },
           "debitAmountData":{
              "currency":"PLN",
              "amount":-1500.00,
              "currencyRate":"",
              "currencyUnit":0
           },
           "creditAmountData":{
              "currency":"PLN",
              "amount":1500.00,
              "currencyRate":"",
              "currencyUnit":0
           },
           "debitAccountData":{
              "accountType":101,
              "accountSequenceNumber":2,
              "branchId":"10900088",
              "accountNo":"26109000880000000142230553",
              "accountName":"GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA"
           },
           "creditAccountData":{
              "accountType":80,
              "accountSequenceNumber":0,
              "branchId":"10901362",
              "accountNo":"55600000020260001418988146",
              "accountName":"ZUS"
           },
           "transactionAmountData":{
              "baseAmount":-1500.00
           },
           "title":"Donation to the Santander Foundation",
           "type":"ZUS_TRANSACTION",
           "valueDate":"2021-11-30",
           "sendApplicationId":21,
           "timestamp":1629986452,
           "options":4,
           "dstPhoneNo":"",
           "ownerCifNumber":1014303930,
           "transactionSide":"TRN_NO_SIDE",
           "noFixedRate":0,
           "customerRef":"",
           "transferType":"ZUS",
           "key":{
              "id":445188,
              "date":"2021-11-30"
           },
           "signHistoryData":[
              {
                 "signLoginId":46425222,
                 "signResult":0,
                 "signTime":"2021-11-30T13:00:57.000",
                 "signTrnState":"ACCEPTED",
                 "signCifNumber":1014303930,
                 "signApplicationId":21
              }
           ],
           "state":"ACCEPTED",
           "sendError":0,
           "postingId":0,
           "acceptanceTime":"2021-11-30T13:00:57.000"
        }
        """.data(using: .utf8)!
        let transaction = try! JSONDecoder().decode(ConfirmationTransferDTO.self, from: jsonData)
        return .success(transaction)
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        fatalError()
    }
}
