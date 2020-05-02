//
//  HTTPRequestBuilder.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

public protocol Builder {
    associatedtype Model
    func build() -> Model
}

public protocol HTTPRequestBuilderProtocol: Builder {
    func set(url: URL) -> Self
    func set(method: HTTPMethod) -> Self
    func set(headers: [String: String]) -> Self
    func set(body: Data) -> Self
}

/// This class is used in order to create a HTTPRequest object
/// It uses the design pattern Builder, So The properties are chainable
public class HTTPRequestBuilder: HTTPRequestBuilderProtocol {

    private var url: URL?
    private var method: HTTPMethod?
    private var headers: [String: String]?
    private var body: Data?
    
    // MARK: - Public API
    
    /// This method is used to set the url for the request
    /// Notice that this this property must be set, otherwise `build()` will return nil
    /// - Parameter url: The URL of the request
    public func set(url: URL) -> Self {
        self.url = url
        return self
    }
    
    /// This method is used to set the HTTPMethod for the request
    /// Notice that this this property must be set, otherwise `build()` will return nil
    /// - Parameter method: The HTTPMethod of the request
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    /// This method is used to set the header of the request
    /// - Parameter headers: The header of the request
    public func set(headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }
    
    /// This method is used to set the Body of the request
    /// - Parameter headers: The body of the request
    public func set(body: Data) -> Self {
        self.body = body
        return self
    }

    /// This method will create an HTTPRequestProtocol from the setted properties
    /// If one of the mandatory properties did not set, nil will be returned
    public func build() -> HTTPRequestProtocol? {
        return createRequest()
    }
   
    // MARK: - Private API
    
    /// This method responsible for validation the mandatory fields
    private func createRequest() -> HTTPRequestProtocol? {
        
        guard let url = url,
            let method = method else {
                return nil
        }
        
        return HTTPRequest(url: url,
                           body: body,
                           method: method,
                           headers: headers)
    }
}


