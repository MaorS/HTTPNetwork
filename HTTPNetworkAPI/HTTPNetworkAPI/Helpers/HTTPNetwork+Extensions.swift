//
//  Extensions.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

extension URLRequest {
    
    /// Create URLRequest from HTTPRequestProtocol
    /// - Parameter request: the HTTPRequestProtocol to create the URLRequest with
    init(request: HTTPRequestProtocol) {
        self.init(url: request.url)
        self.httpMethod = request.method.rawValue
        self.allHTTPHeaderFields = request.headers
        self.httpBody = request.body
    }
}

extension String {
    
    /// This is a optional init with default .utf8 encoding
    /// Note that if the data do not exist nil will be returned
    /// - Parameter data: The data to create the string with
    init?(data: Data?) {
        guard let data = data else { return nil }
        self.init(data: data, encoding: .utf8)
    }
}

extension JSONDecoder {
    
    /// This method is used to decode a data to the specified codable type
    /// Note that if the data do not exist or the decoding proccess failed, nil will be returned
    /// - Parameter data: The data to decode
    func decode<T: Codable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? decode(T.self, from: data)
    }
}
