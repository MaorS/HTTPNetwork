//
//  QueuesProvider.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

/// This class is used to provide the queues for the library
/// The URLSessionDelegate is operated on the delegateQueue
/// that is underlying the root queue.
class HTTPNetworkQueuesProvider {
    
    let rootQueue: DispatchQueue
    let delegateQueue: OperationQueue
    
    init() {
        rootQueue = DispatchQueue(label: "httpNetwork.rootQueue")
        delegateQueue = HTTPNetworkQueuesProvider.createDelegateQueue(underlying: rootQueue)
    }
    
    private static func createDelegateQueue(underlying queue: DispatchQueue) -> OperationQueue {
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .default
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.underlyingQueue = queue
        delegateQueue.name = "\(queue.label).delegateQueue"
        delegateQueue.isSuspended = false
        return delegateQueue
    }
}
