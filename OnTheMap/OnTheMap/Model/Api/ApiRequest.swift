//
//  RequestBuilder.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct ApiRequest<R: Decodable>{
    enum RequestError : Error{
        case responseParseError
    }
    
    enum Method : String{
        case get = "GET", post = "POST"
    }
    
    class Builder{
        private var method: Method
        private var path: String
        private var baseUrl: String
        private var queryArguments: [String: String]
        //private var responseType: R.Type
        
        public init(baseUrl: String){
            self.baseUrl = baseUrl
            self.method = .get
            self.path = "/"
            queryArguments = [String:String]()
        }
        
        public init(request: ApiRequest){
            self.method = request.method
            self.baseUrl = request.baseUrl
            self.path = request.path
            self.queryArguments = request.queryArguments
        }
        
        @discardableResult
        func method(method: Method) -> Builder{
            self.method = method
            return self
        }
        
        @discardableResult
        func baseUrl(url: String) -> Builder{
            self.baseUrl = url
            return self
        }
        
        @discardableResult
        func queryArguments(arguments: [String: String]) -> Builder{
            self.queryArguments = arguments
            return self
        }
        
        @discardableResult
        func addQueryArgument(key: String, value: String) -> Builder{
            queryArguments[key] = value
            return self
        }
        
        @discardableResult
        func path(path: String) -> Builder{
            self.path = path
            return self
        }
        
        func build() -> ApiRequest{
            return ApiRequest<R>(baseUrl: baseUrl, path: path, method: method, queryArguments: queryArguments, responseType: R.self)
        }
    }
    
    let baseUrl: String
    let path: String
    let method: Method
    let queryArguments: [String: String]
    let responseType: R.Type
    
    private func createURLRequest() -> URLRequest{
        var components = URLComponents(url: URL(string: baseUrl)!, resolvingAgainstBaseURL: false)!
        components.path = components.path + path

        components.queryItems = queryArguments.map { (entry) -> URLQueryItem in
            let (key, value) = entry
            return URLQueryItem(name: key, value: value)
        }
        
        print(components)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    @discardableResult
    func execute(callback: @escaping (R?, RequestError?)->Void) -> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: createURLRequest() /*createURLRequest()*/) {
            (data, response, error) in
            var result : R? = nil
            var err : RequestError? = nil
            
            if let data = data{
                do{
                    result = try JSONDecoder().decode(self.responseType, from: data)
                }catch{
                    err = .responseParseError
                }
            }
            DispatchQueue.main.async {
                if(error != nil){
                    callback(nil, err)
                }else{
                    callback(result, nil)
                }
            }
        }
        task.resume()
        return task
    }
}
