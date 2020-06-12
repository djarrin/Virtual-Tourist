//
//  FlickerResponse.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct FlickerResponse: Codable {
    let status: Int
    let error: String
}

extension FlickerResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
