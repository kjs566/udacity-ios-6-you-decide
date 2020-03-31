//
//  ApiPropertyDelegate.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

protocol ApiPropertyDelegate{
    var identifier: String{ get }
    func onPropertyDidChanged()
}
