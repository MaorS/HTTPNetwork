//
//  HTTPNetworkAPITests.swift
//  HTTPNetworkAPITests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import XCTest
@testable import HTTPNetworkAPI

class HTTPNetworkApiCopyTests: BaseTestCase {
    
    var responseError: Error? = nil
    
    /// This test validates the request builder with missing URL parameter
    func testInvalidRequestMissingURL() throws {
        let request = sharedHTTPNetwork
            .makeRequest()
            .set(method: .get)
            .build()
        
        XCTAssertNil(request, "Unexpected result, Missing URL should return nil")
    }
    
    /// This test validates the request builder with missing HTTP method parameter
    func testInvalidRequestMissingHttpMethod() throws {
        let request = sharedHTTPNetwork
            .makeRequest()
            .set(url: urlProvider.response200)
            .build()
        
        XCTAssertNil(request, "Unexpected result, Missing HTTP Method should return nil")
    }
    
    /// This test checks if error returns form the operation when
    /// There are more redirects than allowed
    func testMoreThanAllowedNumberOfRedirects() throws {
        
        let network = createHTTPNetwork(maxRedirections: 3)
        let request = network.makeRequest()
            .set(url: urlProvider.redirects)
            .set(method: .get)
            .build()!
        
        network.execute(request: request, onSuccess: { _ in
            XCTAssert(true, "Response Should not be received")
        }) { (error) in
            self.responseError = error
            if let error = error as? HTTPNetworkError {
                print(error.localizedDescription)
            } else {
                XCTAssert(true, "Error is not HttpNetworkError")
            }
        }
        
        let responseErrorPred = NSPredicate(format: "responseError != nil")
        let exp = expectation(for: responseErrorPred, evaluatedWith: self, handler: nil)
        
        let res = XCTWaiter.wait(for: [exp], timeout: timeout)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(responseError, "Unexpected error result, should not be nil")
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
}
