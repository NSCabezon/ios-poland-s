public enum MobileTransferSummaryViewModel {
    public struct TrustedDeviceInfo {
        let label: String
        let type: String
    }
    
    public struct UntrustedDeviceInfo {
        public enum DeviceType: String {
            case cookie
            case UID
        }
        
        let alias: String
        let type: String
    }
    
    case trustedDevice(TrustedDeviceInfo)
    case untrustedDevice(UntrustedDeviceInfo)
    case none
}
