//
//  PhotoSizes.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct PhotoSizes:Codable {
    let label: String
    let width: Int
    let height: Int
    let source: String
    let url: String
    let media: String
}
