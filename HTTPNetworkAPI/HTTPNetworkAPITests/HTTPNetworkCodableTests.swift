//
//  HTTPNetworkCodableTests.swift
//  HTTPNetworkAPITests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import XCTest
@testable import HTTPNetworkAPI

class HTTPNetworkCodableTests: BaseTestCase {
    
    var responsePerson: Person? = nil
    var responseError: Error? = nil
    var responseIsNil: Bool = false
    
    /// This test checks for response codable object
    func testRequestWithResponseCodable() throws {
        
        let network = createHTTPNetwork()
        let request = network.makeRequest()
            .set(url: urlProvider.person)
            .set(method: .get)
            .build()!
        
        network.execute(request: request,
                        onSuccess: { (person: Person?) in
                            if let person = person {
                                self.responsePerson = person
                            } else {
                                self.responseIsNil = true
                            }
        }) { (error) in
            self.responseError = error
        }
        
        let responsePersonPred = NSPredicate(format: "responsePerson != nil")
        let responseNilPred = NSPredicate(format: "responseIsNil == true")
        let responseErrorPred = NSPredicate(format: "responseError != nil")
        let pred = NSCompoundPredicate(type: .or, subpredicates: [responseErrorPred,
                                                                  responsePersonPred,
                                                                  responseNilPred])
        
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        
        let res = XCTWaiter.wait(for: [exp], timeout: timeout)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(responsePerson, "No Person received")
            XCTAssertNil(responseError, "Unexpected error result")
            XCTAssertFalse(responseIsNil, "An error occurred while receiving data from server")
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
}
