//
//  ApiError.swift
//  VirtualTourist
//
//  Created by Jan Skála on 02/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

enum ApiError : Error{
    case networkError(error: Error)
    case errorResponse(response: ErrorResponse)
    case parseError
}
