import Foundation

public struct P2pAliasDTO: Codable {
    public let dstAccNo: String
    public let isDstAccInternal: Bool
    
    public init(dstAccNo: String, isDstAccInternal: Bool) {
        self.dstAccNo = dstAccNo
        self.isDstAccInternal = isDstAccInternal
    }
}
