public enum AccountForDebitTypeDTO: String, Codable {
    case avista = "AVISTA"
    case savings = "SAVINGS"
    case deposit = "DEPOSIT"
    case creditCard = "CREDIT_CARD"
    case loan = "LOAN"
    case investment = "INVESTMENT"
    case vat = "VAT"
    case sLink = "SLINK"
    case efx = "EFX"
    case other = "OTHER"
    case personal = "PERSONAL"
}
