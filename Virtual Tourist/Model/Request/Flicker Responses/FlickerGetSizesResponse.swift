//
//  FlickerGetSizesResponse.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct FlickerGetSizesResponse:Codable {
    let stat: String
    let sizes: Sizes
}

struct Sizes:Codable {
    let canblog: Int
    let canprint: Int
    let candownload: Int
    let size: [PhotoSizes]
}
