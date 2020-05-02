//
//  BaseTestCase.swift
//  HTTPNetworkAPITests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import HTTPNetworkAPI
import XCTest

class BaseTestCase: XCTestCase {
    
    let timeout: TimeInterval = 5.0
    let urlProvider = URLProvider.self
    let mockProvider = MockProvider.self
    
    let sharedHTTPNetwork = HTTPNetwork()
    
    /// Create HTTPNetwork with specified max number of redirections
    /// - Parameter maxRedirections: the max number of redirections
    func createHTTPNetwork(maxRedirections: Int) -> HTTPNetwork {
        return HTTPNetwork(configuration: HTTPNetworkConfiguration(maxRedirections: maxRedirections))
    }
    
    /// Create HTTPNetwork with no configuation
    func createHTTPNetwork() -> HTTPNetwork {
        return HTTPNetwork()
    }
}
