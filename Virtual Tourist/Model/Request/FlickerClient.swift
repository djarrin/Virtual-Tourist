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
    // I wanted to keep this here rather than adding it as a parameter because
    // this option could hender performance of other methods within the app
    static let photosPerPage = 12
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/?api_key=\(FlickerClient.apiKey)&&format=json&nojsoncallback=1&"
        
        case search(String)
        case getSource(String)
        
        var stringValue: String {
            switch self {
            case .search(let parameters): return Endpoints.base + "method=flickr.photos.search&per_page=\(FlickerClient.photosPerPage)&" + parameters
            case .getSource(let parameters): return Endpoints.base + "method=flickr.photos.getSizes&" + parameters
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func photoSearch(latitude: Double, longitude: Double, page: Int = 1, completion: @escaping (FlickerPhotoSearchResponse?, Error?) -> Void) {
        _get(url: Endpoints.search("lat=\(latitude)&lon=\(longitude)&page=\(page)").url, response: FlickerPhotoSearchResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getSource(photoID: String, completion: @escaping (FlickerGetSizesResponse?, Error?) -> Void) {
        _get(url: Endpoints.getSource("photo_id=\(photoID)").url, response: FlickerGetSizesResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let download = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        download.resume()
    }
    
    @discardableResult class func _get<ResponseType: Decodable>(url: URL, response: ResponseType.Type, stripResonse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(FlickerResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
}
