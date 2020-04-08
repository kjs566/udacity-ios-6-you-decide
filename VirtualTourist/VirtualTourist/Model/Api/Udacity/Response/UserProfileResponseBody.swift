//
//  UserProfileResponseBody.swift
//  VirtualTourist
//
//  Created by Jan Skála on 07/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct UserProfileResponseBody: Codable{
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
