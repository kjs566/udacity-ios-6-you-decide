//
//  RequestBuilder.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct ApiRequest{
    enum Method{
        case get, post
    }
    class Builder{
        var method: Method = .get
        var path: String = ""
        var baseUrl: String = ""
        var queryArguments = [String:String]()
        
        public init(){}
        public init(request: ApiRequest){
            self.method = request.method
            self.baseUrl = request.baseUrl
            self.path = request.path
            self.queryArguments = request.queryArguments
        }
        
        func method(method: Method) -> Builder{
            self.method = method
            return self
        }
        
        func baseUrl(url: String) -> Builder{
            self.baseUrl = url
            return self
        }
        
        func queryArguments(arguments: [String: String]) -> Builder{
            self.queryArguments = arguments
            return self
        }
        
        func addQueryArgument(key: String, value: String) -> Builder{
            queryArguments[key] = value
            return self
        }
        
        func build() -> ApiRequest{
            return ApiRequest(baseUrl: baseUrl, path: path, method: method, queryArguments: queryArguments)
        }
    }
    
    let baseUrl: String
    let path: String
    let method: Method
    let queryArguments: [String: String]
    
    private func createUrlRequest() -> URLRequest{
        var components = URLComponents(string: baseUrl)!
        components.path = path

        components.queryItems = queryArguments.map { (entry) -> URLQueryItem in
            let (key, value) = entry
            return URLQueryItem(name: key, value: value)
        }
        
        return URLRequest(url: components.url!)
    }
    
    public func forceReload(){
        
    }
}
