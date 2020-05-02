//
//  HTTPNetworkConfiguration.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

/// The configuation settings of the library
public struct HTTPNetworkConfiguration {
    public let maxRedirections: Int?
    
    public init(maxRedirections: Int? = nil) {
        self.maxRedirections = maxRedirections
    }
}

