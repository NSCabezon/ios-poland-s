public enum PLTimeFormat: String {
    case YYYYMMDD_HHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case YYYYMMDD_HHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case ddMMyyyyDotted = "dd.MM.yyyy"
    case ddMMyyyyDash = "dd-MM-yyyy"
    
    
    public func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter
    }
}
