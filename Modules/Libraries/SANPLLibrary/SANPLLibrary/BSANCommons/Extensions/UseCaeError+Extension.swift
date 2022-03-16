
import CoreFoundationLib

extension UseCaseError {
    public func getPLErrorDTO() -> PLErrorDTO? {
        let data = Data((self.getErrorDesc() ?? "").utf8)
        return try? JSONDecoder().decode(PLErrorDTO.self, from: data)
    }
}
