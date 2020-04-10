//
//  PhotosResponse.swift
//  VirtualTourist
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct PhotosResponse : Decodable{
    let page: Int
    let pages: Int
    let total: Int
    let perPage: Int
    let photo: [Photo]
    
    struct Photo : Decodable {
        let id: String
        let title: String
    }
}
