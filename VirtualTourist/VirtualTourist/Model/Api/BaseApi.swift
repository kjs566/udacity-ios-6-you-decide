//
//  BaseApiClient.swift
//  VirtualTourist
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class BaseApi{
    let baseUrl: String
    
    init(baseUrl: String){
        self.baseUrl = baseUrl
    }
    
    open func requestBuilder<R: Decodable>() -> ApiRequest<R>.Builder{
        return ApiRequest<R>.Builder(baseUrl: baseUrl)
    }
    
    open func apiProperty<R: Decodable>(id: String = "", request: ApiRequest<R>? = nil) -> ApiProperty<R>{
        return ApiProperty<R>(withId: id, andRequest: request)
    }
    
    func getCookies() -> [HTTPCookie]?{
        return HTTPCookieStorage.shared.cookies
    }
    
    func getCookieValue(name: String) -> String?{
        if let cookies = getCookies(){
            for cookie in cookies {
                if cookie.name == name {
                    return cookie.value
                }
            }
        }
        
        return nil
    }
}
