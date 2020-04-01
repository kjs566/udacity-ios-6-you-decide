//
//  CreateSessionResponseBody.swift
//  OnTheMap
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct CreateSessionResponseBody : Codable{
    let account: Account
    let session: Session
    
    struct Account : Codable{
        let registered: Bool
        let key: String
    }
    struct Session : Codable{
        let id : String
        let expiration: String
    }
}
