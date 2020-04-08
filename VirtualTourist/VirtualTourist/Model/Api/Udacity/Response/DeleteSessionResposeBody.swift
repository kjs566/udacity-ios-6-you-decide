//
//  DeleteSessionResponseBody.swift
//  VirtualTourist
//
//  Created by Jan Skála on 01/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct DeleteSessionResponseBody : Codable{
    let session: Session
    
    struct Session : Codable{
        let id: String
        let expiration: String
    }
}
