//
//  SizesResponse.swift
//  VirtualTourist
//
//  Created by Jan Skála on 11/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct SizesResponse : Codable{
    let sizes : Sizes?
    
    struct Sizes: Codable {
        let canDownload: Int?
        let size: [Size]
    }
    
    struct Size: Codable {
        let label: String?
        let width: Int
        let height: Int
        let source: String
    }
}
