import SANPLLibrary

protocol PubKeyModelMapping {
    func map(dto: PubKeyDTO) -> PubKey
}

class PubKeyModelMapper: PubKeyModelMapping {
    func map(dto: PubKeyDTO) -> PubKey {
        PubKey(modulus: dto.modulus, exponent: dto.exponent)
    }
}
