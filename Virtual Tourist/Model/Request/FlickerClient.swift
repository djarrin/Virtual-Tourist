//
//  FlickerClient.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 5/1/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

class FlickerClient {
    
    static let apiKey = "6dbfc3a7af64568fe06795dfa3be200b"
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/?api_key=\(FlickerClient.apiKey)&&format=json&nojsoncallback=1&"
        
        case search(String)
        case getSource(String)
        
        var stringValue: String {
            switch self {
            case .search(let parameters): return Endpoints.base + "method=flickr.photos.search&" + parameters
            case .getSource(let parameters): return Endpoints.base + "method=flickr.photos.getSizes&" + parameters
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
