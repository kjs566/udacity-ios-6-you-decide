//
//  ParseApiClient.swift
//  VirtualTourist
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ParseApi : BaseApi{
    // Is this ok? Or is it better to use variable in AppDelegate to share this?
    static let shared = ParseApi()
    
    private init(){
        super.init(baseUrl: "https://VirtualTourist-api.udacity.com")
    }
    
    func placeLocation(firstName: String, lastName: String, address: String, url: String, lat: Double, lon: Double){
        let random = Int.random(in: 0...999999)
        let uniqueKey = "on-the-map-kjs566-\(random)"
        let request : ApiRequest<PostLocationResponseBody> = requestBuilder().path("/v1/StudentLocation")
            .method(.post)
            .body(PostLocationRequestBody(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: address, mediaURL: url, latitude: lat, longitude: lon))
            .build()
        postLocationProperty.load(request: request)
    }
    
    lazy var studentLocationsRequest : ApiRequest<StudentLocationsResponseBody> = requestBuilder().path("/v1/StudentLocation")
        .addQueryArgument(key: "limit", value: "100")
        .addQueryArgument(key: "order", value: "-updatedAt")
            .build()
    
    lazy var studentLocationsProperty : ApiProperty<StudentLocationsResponseBody> = ApiProperty(withId:  "DeleteSession", andRequest: studentLocationsRequest)
    
    lazy var postLocationProperty : ApiProperty<PostLocationResponseBody> =
        ApiProperty(withId: "PostLocation")
}
