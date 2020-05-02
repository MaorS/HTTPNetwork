//
//  HTTPNetworkStringTests.swift
//  HTTPNetworkAPITests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import XCTest
@testable import HTTPNetworkAPI

class HTTPNetworkStringTests: BaseTestCase {
    
    var responseString: String? = nil
    var responseError: Error? = nil
    var responseIsNil: Bool = false
    
    /// This methods checks If the operation failed because of unspecified body
    func testRequestMissingBody() throws {
        
        let network = createHTTPNetwork()
        let request = network.makeRequest()
            .set(url: urlProvider.post)
            .set(method: .post)
            .set(headers: mockProvider.authHeader())
            .build()!
        
        network.execute(request: request, onSuccess: {
            self.responseString = $0
            if $0 == nil {
                self.responseIsNil = true
            }
        }) { (error) in
            self.responseError = error
        }
        
        let responseStringPred = NSPredicate(format: "responseString != nil")
        let responseNilPred = NSPredicate(format: "responseIsNil == true")
        let responseErrorPred = NSPredicate(format: "responseError != nil")
        let pred = NSCompoundPredicate(type: .or, subpredicates: [responseErrorPred,
                                                                  responseStringPred,
                                                                  responseNilPred])
        
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        
        let res = XCTWaiter.wait(for: [exp], timeout: timeout)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(responseString, "No data received from the server")
            XCTAssertNil(responseError, "Unexpected error result")
            XCTAssertFalse(responseIsNil, "An error occurred while receiving data from server")
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
    /// This methods checks if the request body sent successfuly
    /// https://maor.requestcatcher.com/
    func testRequestWithBody() throws {
        
        let network = createHTTPNetwork()
        let request = network.makeRequest()
            .set(url: urlProvider.post)
            .set(body: mockProvider.bodyData())
            .set(method: .post)
            .build()!
        
        network.execute(request: request, onSuccess: {
            self.responseString = $0
            if $0 == nil {
                self.responseIsNil = true
            }
        }) { (error) in
            self.responseError = error
        }
        
        let responseStringPred = NSPredicate(format: "responseString != nil")
        let responseNilPred = NSPredicate(format: "responseIsNil == true")
        let responseErrorPred = NSPredicate(format: "responseError != nil")
        let pred = NSCompoundPredicate(type: .or, subpredicates: [responseErrorPred,
                                                                  responseStringPred,
                                                                  responseNilPred])
        
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        
        let res = XCTWaiter.wait(for: [exp], timeout: timeout)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(responseString, "No data received from the server")
            XCTAssertNil(responseError, "Unexpected error result")
            XCTAssertFalse(responseIsNil, "An error occurred while receiving data from server")
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
    /// This method checks handling of unsuccessful response code
    func testRequestWithResponseError400() throws {
        
        let network = createHTTPNetwork()
        let request = network.makeRequest()
            .set(url: urlProvider.response400)
            .set(method: .get)
            .build()!
        
        network.execute(request: request, onSuccess: {
            self.responseString = $0
            if $0 == nil {
                self.responseIsNil = true
            }
        }) { (error) in
            self.responseError = error
            if let error = error as? HTTPNetworkError {
                print(error.localizedDescription)
            } else {
                XCTAssert(true, "Error is not HttpNetworkError")
            }
        }
        
        let responseStringPred = NSPredicate(format: "responseString != nil")
        let responseNilPred = NSPredicate(format: "responseIsNil == true")
        let responseErrorPred = NSPredicate(format: "responseError != nil")
        let pred = NSCompoundPredicate(type: .or, subpredicates: [responseErrorPred,
                                                                  responseStringPred,
                                                                  responseNilPred])
        
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        
        let res = XCTWaiter.wait(for: [exp], timeout: timeout)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(responseError, "No Error received from server")
            XCTAssertNil(responseString, "Unexpected error result")
            XCTAssertFalse(responseIsNil, "An error occurred while receiving data from server")
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
}
