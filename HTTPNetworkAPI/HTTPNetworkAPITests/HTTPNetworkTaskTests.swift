//
//  HTTPNetworkTaskTests.swift
//  HTTPNetworkAPITests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import XCTest
@testable import HTTPNetworkAPI

class HTTPNetworkTaskTests: BaseTestCase {
    
    var didFinishTask = false
    
    /// This method checks if the library removed the task after successful completion
    func testSuccess() {
        
        let httpNetwork = createHTTPNetwork()
        let request = httpNetwork
            .makeRequest()
            .set(url: urlProvider.response200)
            .set(method: .get)
            .build()!
        
        httpNetwork.execute(request: request,
                            onSuccess: { _ in
                                self.didFinishTask = true
        }) { _ in
            self.didFinishTask = true
        }
        
        if XCTWaiter.wait(for: [], timeout: 0.2) == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 1, "We should have 1 item" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
        
        let responsePred = NSPredicate(format: "didFinishTask != false")
        let responseExp = expectation(for: responsePred, evaluatedWith: self, handler: nil)
        
        let responseRes = XCTWaiter.wait(for: [responseExp], timeout: timeout)
        if responseRes == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 0, "We should have 0 items" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
    /// This method checks if the library removed the task after response fail completion
    func testFailResponseCode() throws {
        
        let httpNetwork = createHTTPNetwork()
        let request = httpNetwork.makeRequest()
            .set(url: urlProvider.response400)
            .set(method: .get)
            .build()!
        
        httpNetwork.execute(request: request,
                            onSuccess: { _ in
                                self.didFinishTask = true
        }) { _ in
            self.didFinishTask = true
        }
        
        if XCTWaiter.wait(for: [], timeout: 0.2) == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 1, "We should have 1 item" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
        
        let responsePred = NSPredicate(format: "didFinishTask != false")
        let responseExp = expectation(for: responsePred, evaluatedWith: self, handler: nil)
        
        let responseRes = XCTWaiter.wait(for: [responseExp], timeout: timeout)
        if responseRes == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 0, "We should have 0 items" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
    /// This method checks if the library removed the task after request fail completion
    func testFailRequest() throws {
        
        let httpNetwork = createHTTPNetwork(maxRedirections: 2)
        let request = httpNetwork.makeRequest()
            .set(url: urlProvider.redirects)
            .set(method: .get)
            .build()!
        
        httpNetwork.execute(request: request,
                            onSuccess: { _ in
                                self.didFinishTask = true
        }) { _ in
            self.didFinishTask = true
        }
        
        if XCTWaiter.wait(for: [], timeout: 0.2) == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 1, "We should have 1 item" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
        
        let responsePred = NSPredicate(format: "didFinishTask != false")
        let responseExp = expectation(for: responsePred, evaluatedWith: self, handler: nil)
        
        let responseRes = XCTWaiter.wait(for: [responseExp], timeout: timeout)
        if responseRes == XCTWaiter.Result.completed {
            XCTAssertTrue(httpNetwork.tasks.count == 0, "We should have 0 items" );
        } else {
            XCTAssert(false, "The call ran into some other error")
        }
    }
    
    
}
