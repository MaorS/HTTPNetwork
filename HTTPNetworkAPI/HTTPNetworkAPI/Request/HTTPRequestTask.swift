//
//  HTTPRequestTask.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

/// This class is used to wrap the HTTPRequest with the URLSessionTask and
/// some other properties of the task
class HTTPRequestTask {
    
    let request: HTTPRequestProtocol
    let urlSessionTask: URLSessionTask
    
    /// The number of the current redirects that was made during this task
    var redirectCount = 0
    
    init(request: HTTPRequestProtocol, urlSessionTask: URLSessionTask) {
        self.request = request
        self.urlSessionTask = urlSessionTask
    }
    
    var id: Int {
        return urlSessionTask.taskIdentifier
    }
}
