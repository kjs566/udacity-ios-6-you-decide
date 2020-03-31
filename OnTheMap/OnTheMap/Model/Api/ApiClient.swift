//
//  ApiClient.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
class BaseApiClient{
    func call(){
        let request = ApiRequest.Builder().build()
        URLSession.shared.dataTask(with: request, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
    }
}
