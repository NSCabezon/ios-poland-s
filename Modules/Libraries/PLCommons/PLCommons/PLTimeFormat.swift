public enum PLTimeFormat: String {
    case YYYYMMDD_HHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case ddMMyyyyDotted = "dd.MM.yyyy"
    
    public func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter
    }
}
