//
//  Photo.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation


struct FlickerPhoto: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
