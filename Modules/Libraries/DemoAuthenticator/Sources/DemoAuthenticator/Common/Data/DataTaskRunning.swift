//
//  DataTaskRunning.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol DataTaskRunning {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
