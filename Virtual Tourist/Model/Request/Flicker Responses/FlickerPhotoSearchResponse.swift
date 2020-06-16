//
//  FlickerPhotoSearchResponse.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct FlickerPhotoSearchResponse: Codable {
    let stat: String
    let photos: PhotoReturnObject
}

struct PhotoReturnObject: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickerPhoto]
}
