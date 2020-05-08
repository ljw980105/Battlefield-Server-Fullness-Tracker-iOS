//
//  Alamofire+TypedJSONResponse.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/3/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Alamofire
import Combine
import Foundation

extension Session {
    func requestTyped<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: [String: String],
        transformData: @escaping (Data) throws -> Data? = { $0 }) -> Future<T, Error>
    {
        return Future { promise in
            AF.request(
                endpoint,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(headers)).responseJSON
            { json in
                if let data = json.data {
                    do {
                        let transformedData = try transformData(data)
                        let resp = try JSONDecoder().decode(T.self, from: transformedData ?? data)
                        promise(.success(resp))
                    } catch let err {
                        promise(.failure(err))
                    }
                } else if let error = json.error {
                    promise(.failure(error))
                }
            }
        }
    }
}
