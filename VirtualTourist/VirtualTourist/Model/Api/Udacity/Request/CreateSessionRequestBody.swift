//
//  CreateSessionRequestBody.swift
//  VirtualTourist
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct CreateSessionRequestBody : Codable{
    let udacity: LoginData
    
    struct LoginData : Codable{
        let username: String
        let password: String
    }
    
    init(username: String, password: String) {
        self.udacity = LoginData(username: username, password: password)
    }
}
