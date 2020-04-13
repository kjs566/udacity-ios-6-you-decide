//
//  RequestBuilder.swift
//  VirtualTourist
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct ApiRequest<R: Decodable>{
    enum Method : String{
        case get = "GET", post = "POST", delete = "DELETE"
    }
    
    class Builder{
        private var method: Method
        private var path: String
        private var baseUrl: String
        private var queryArguments: [String: String]
        private var headers: [String: String]
        private var body: String?
        private var responseOffset: Int
        
        public init(baseUrl: String){
            self.baseUrl = baseUrl
            self.method = .get
            self.path = "/"
            self.queryArguments = [String:String]()
            self.headers = [String:String]()
            self.body = nil
            self.responseOffset = 0
        }
        
        public init(withRequest request: ApiRequest){
            self.method = request.method
            self.baseUrl = request.baseUrl
            self.path = request.path
            self.queryArguments = request.queryArguments
            self.body = request.body
            self.headers = request.headers
            self.responseOffset = request.responseOffset
        }
        
        func method(_ method: Method) -> Builder{
            self.method = method
            return self
        }
        
        func baseUrl(_ url: String) -> Builder{
            self.baseUrl = url
            return self
        }
        
        func queryArguments(_ arguments: [String: String]) -> Builder{
            self.queryArguments = arguments
            return self
        }
        
        func addQueryArgument(key: String, value: String) -> Builder{
            self.queryArguments[key] = value
            return self
        }
        
        func headers(_ headers: [String: String]) -> Builder{
            self.headers = headers
            return self
        }
        
        func addHeader(key: String, value: String) -> Builder{
            self.headers[key] = value
            return self
        }
        
        func body(_ body: String?) -> Builder{
            self.body = body
            return self
        }
        
        func body<E: Encodable>(_ encodable: E) -> Builder{
            do{
                self.body = try String(data: JSONEncoder().encode(encodable), encoding: .utf8)
            }catch {
                print("Coundn't parse request body.")
                self.body = nil
            }
            return self
        }
        
        func path(_ path: String) -> Builder{
            self.path = path
            return self
        }
        
        func responseOffset(_ offset: Int) -> Builder{
            self.responseOffset = offset
            return self
        }
        
        func build() -> ApiRequest{
            return ApiRequest<R>(baseUrl: baseUrl, path: path, method: method, queryArguments: queryArguments, responseType: R.self, headers: headers, body: body, responseOffset: responseOffset)
        }
    }
    
    let baseUrl: String
    let path: String
    let method: Method
    let queryArguments: [String: String]
    let responseType: R.Type
    let headers: [String: String]
    let body: String?
    let responseOffset: Int
    
    private func createURLRequest() -> URLRequest{
        var components = URLComponents(url: URL(string: baseUrl)!, resolvingAgainstBaseURL: false)!
        components.path = components.path + path

        if queryArguments.count > 0 {
            components.queryItems = queryArguments.map { (entry) -> URLQueryItem in
                let (key, value) = entry
                return URLQueryItem(name: key, value: value)
            }
        }
        
        print(components)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        headers.forEach { entry in
            let (key, value) = entry
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = body?.data(using: .utf8)
        
        return request
    }
    
    
    @discardableResult
    func execute(callback: @escaping (R?, ApiError?)->Void) -> URLSessionDataTask{
        let request = createURLRequest()
        print("ApiRequest: \(request.httpMethod ?? "nil") \(request.url?.absoluteString ?? "") \n Headers: \n \(request.allHTTPHeaderFields ?? [:])) \n Body: \n \(String(data: request.httpBody ?? Data(), encoding: .utf8)!)")
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            var result : R? = nil
            var err : ApiError? = nil
            
            if let error = error{
                err = .networkError(error: error)
            }else{
                if let data = data{
                    print("ApiResponse:")
                    print(String(data: data, encoding: .utf8) ?? "")
                    do{
                        let offseted = data.subdata(in: self.responseOffset..<data.count)
                        
                        result = try JSONDecoder().decode(self.responseType, from: offseted)
                    }catch{
                        err = .parseError
                    }
                }
            }
        
            DispatchQueue.main.async {
                if let err = err {
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
