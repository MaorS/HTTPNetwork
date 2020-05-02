//
//  MockProvider.swift
//  HttpNetworkApiCopyTests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

typealias JSON = [String: String]

struct MockProvider {
    
    static func authHeader() -> JSON {
        return ["user": "Maor",
                "passwd": "123456"]
    }
    
    static func bodyData() -> Data {
        return """
        {
        "user": "Maor",
        "passwd": "123456"
        }
        """.data(using: .utf8)!
    }
}
