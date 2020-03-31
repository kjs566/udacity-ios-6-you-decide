//
//  BaseApiClient.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class BaseApiClient{
    let baseUrl: String
    
    init(baseUrl: String){
        self.baseUrl = baseUrl
    }
    
    func requestBuilder<R: Decodable>() -> ApiRequest<R>.Builder{
        return ApiRequest<R>.Builder(baseUrl: baseUrl)
    }
    
    func apiProperty<R: Decodable>(request: ApiRequest<R>) -> ApiProperty<R>{
        return ApiProperty<R>(withRequest: request)
    }
}
