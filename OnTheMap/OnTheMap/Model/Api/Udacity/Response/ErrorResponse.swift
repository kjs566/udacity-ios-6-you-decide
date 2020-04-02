//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Jan Skála on 02/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct ErrorResponse : Codable{
    let status: Int?
    let error: String?
}
