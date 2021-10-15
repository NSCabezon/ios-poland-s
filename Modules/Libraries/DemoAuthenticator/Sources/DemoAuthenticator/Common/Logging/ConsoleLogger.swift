//
//  ConsoleLogger.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 22/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

public final class ConsoleLogger {
    public enum Level: Int {
        case verbose = 0
        case info = 1
        case warning = 2
        case error = 3
        
        var name: String {
            switch self {
            case .verbose:
                return "VERBOSE"
            case .info:
                return "INFO"
            case .warning:
                return "WARNING"
            case .error:
                return "ERROR"
            }
        }
    }
    
    private let level: Level
    
    public init(level: ConsoleLogger.Level) {
        self.level = level
    }
}

extension ConsoleLogger: Logger {
    func info(message: () -> String?) {
        log(level: .info, message: message)
    }
        
    private func log(level: Level, message: () -> String?) {
        guard
            level.rawValue >= self.level.rawValue,
            let message = message()
        else {
            return
        }
        
        print("[\(level.name)] \(message)")
    }
}
