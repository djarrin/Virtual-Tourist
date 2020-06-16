//
//  FlickerResponse.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 6/12/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct FlickerResponse: Codable {
    let stat: String
    let code: Int?
    let message: String?
}

extension FlickerResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
