import Foundation
import SANPLLibrary
import CoreFoundationLib

//Note, formats may vary as TimeManager doesn't have locale set.
final class FakeTimeManager: TimeManager {
    
    public func fromString(input: String?, inputFormat: String, timeZone: TimeManagerTimeZone) -> Date? {
        guard let input = input else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        if timeZone == .utc {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        return dateFormatter.date(from: input)
    }
    
    public func fromString(input: String?, inputFormat: String) -> Date? {
        guard let input = input else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: input)
    }
    
    public func fromString(input: String?, inputFormat: TimeFormat, timeZone: TimeManagerTimeZone) -> Date? {
        guard let input = input else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        if timeZone == .utc {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        return dateFormatter.date(from: input)
    }
    
    public func fromString(input: String?, inputFormat: TimeFormat) -> Date? {
        guard let input = input else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: input)
    }
    
    public func toString(input: String?, inputFormat: TimeFormat, outputFormat: TimeFormat) -> String? {
        guard let input = input,
              let date = fromString(input: input, inputFormat: inputFormat)
        else { return nil }
        return toString(date: date, outputFormat: outputFormat)
    }
    
    public func toString(date: Date?, outputFormat: TimeFormat) -> String? {
        return toString(date: date, outputFormat: outputFormat, timeZone: .utc)
    }
    
    public func toString(date: Date?, outputFormat: TimeFormat, timeZone: TimeManagerTimeZone) -> String? {
        guard let date = date, isValidDate(date) else { return nil }
        switch outputFormat {
        case .MMM:
            return getShortenedMonth(date: date)
        case .MMMM:
            return getMonth(date: date)
        case .asteriskedDate:
            fatalError()
        case .eeee:
            return getWeekday(date: date)
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = outputFormat.rawValue
            if timeZone == .utc {
                formatter.timeZone = TimeZone(identifier: "UTC")
            }
            return formatter.string(from: date).replacingOccurrences(of: ".", with: "").lowercased()
        }
    }
    
    public func getShortenedMonth(date: Date) -> String? {
        return getMonth(date: date).substring(0, 3)
    }
    
    public func getMonth(date: Date) -> String {
        fatalError()
    }
    
    public func getWeekday(date: Date) -> String {
        fatalError()
        }
    
    public func toStringFromCurrentLocale(date: Date?, outputFormat: TimeFormat) -> String? {
        guard let date = date, isValidDate(date) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = outputFormat.rawValue
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date).lowercased()
    }
    
    public func getCurrentLocaleDate(inputDate: Date?) -> Date? {
        let todayString = toString(date: inputDate, outputFormat: .yyyy_MM_ddHHmmss, timeZone: .local)
        return fromString(input: todayString, inputFormat: TimeFormat.yyyy_MM_ddHHmmss, timeZone: .utc)
    }
    
    public func isValidDate(_ date: Date) -> Bool {
        return isValidYear(date.year)
    }
    
    public func isValidYear(_ year: Int) -> Bool {
        return !(year == 9999 || year == 1)
    }
}

