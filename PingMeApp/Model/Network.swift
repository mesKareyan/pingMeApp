//
//  Network.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

enum NetworkResult {
    case success(pingTime: TimeInterval)
    case failure(error: Error)
}
enum NetworkError: Error {
    case badURL
    case notHTTPResponse
    case badResonse(code: Int, description: String)
}
typealias NetworkOperationCompletion = (NetworkResult) -> ()

class Network {
    
    static let session = URLSession.shared;
    
    static func checkPing(for url: String, completion: @escaping NetworkOperationCompletion) {
        guard let url = URL(string: url) else {
            completion(.failure(error: NetworkError.badURL))
            return
        }
        let startTime = Date()
        session.dataTask(with: url) { (data, response, error) in
                let pingTime = Date().timeIntervalSince(startTime)
                if let error = error {
                    completion(.failure(error: error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(error: NetworkError.notHTTPResponse))
                    return
                }
                let statusCode = httpResponse.statusCode
                if 200 ... 299 ~= statusCode {
                    completion(.success(pingTime: pingTime))
                    return
                }
                let desc = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                completion(.failure(error: NetworkError.badResonse(code: statusCode, description: desc)))
        }.resume()
    }
}
