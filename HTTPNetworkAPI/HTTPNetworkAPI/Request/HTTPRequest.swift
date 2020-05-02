//
//  HTTPRequest.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

/// HTTPRequestProtocol is the blueprint of the HTTPRequest
public protocol HTTPRequestProtocol {
    var id: String { get }
    var url: URL { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

///Immutable HTTPRequest Model
public struct HTTPRequest: HTTPRequestProtocol {
    
    public let id: String
    public let url: URL
    public let body: Data?
    public let method: HTTPMethod
    public let headers: [String: String]?
    
    init(url: URL,
         body: Data? = nil,
         method: HTTPMethod,
         headers: [String: String]? = nil) {
        
        self.id = UUID().uuidString
        self.url = url
        self.body = body
        self.method = method
        self.headers = headers
    }
}

