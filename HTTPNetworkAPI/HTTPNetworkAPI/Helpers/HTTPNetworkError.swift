//
//  HTTPNetworkError.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

/// This is the error wrapper for the request tasks
public enum HTTPNetworkError: Error {

    /// The number of redirects is exceeding the defined
    case exceedNumOfRedirections(redirections: Int)
    /// The response returns with error and status code that is not Successful responses
    case responseError(statusCode: Int)
    
    
    /// The description of the error
    public var localizedDescription: String {
        switch self {
        case .exceedNumOfRedirections(let num):
            return buildErrorMessage(with: "The Number of redirects \(num) has exceeded than defined")
        case .responseError(let statusCode):
            return buildErrorMessage(with: "The Response returned with statusCode: \(statusCode)")
        }
    }
    
    /// The main error description
    private static var mainDecription: String {
        return "HttpNetworkError Occured:  "
    }
    
    /// Concat the error message with the mainDecription
    /// - Parameter message: The message to concat
    func buildErrorMessage(with message: String) -> String {
        return HTTPNetworkError.mainDecription.appending(message)
    }
}

