//
//  UrlProvider.swift
//  HttpNetworkApiCopyTests
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

struct URLProvider {

    static var redirects: URL {
        return URL(string: "http://www.mocky.io/v2/5e0af46b3300007e1120a7ef")!
    }
    
    static var person: URL {
        return URL(string: "http://www.mocky.io/v2/5eac61de3300008524dfe374")!
    }
    
    static var response200: URL {
        return URL(string: "http://www.mocky.io/v2/5ead49d82f00006600198712")!
    }
    
    static var response400: URL {
        return URL(string: "http://www.mocky.io/v2/5ead49492f00004d0019870d")!
    }

    static var post: URL {
        return URL(string: "https://maor.requestcatcher.com/test")!
    }

    
    
}
