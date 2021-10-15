//
//  Logger.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 22/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol Logger {
    func info(message: () -> String?)
}
