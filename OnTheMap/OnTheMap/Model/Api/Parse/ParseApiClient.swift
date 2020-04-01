//
//  ParseApiClient.swift
//  OnTheMap
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ParseApiClient : BaseApiClient{
    // Is this ok? Or is it better to use variable in AppDelegate to share this?
    static let shared = ParseApiClient()
    
    private init(){
        super.init(baseUrl: "https://onthemap-api.udacity.com")
    }
    
    lazy var studentLocationsRequest : ApiRequest<StudentLocationsResponseBody> = requestBuilder().path("/v1/StudentLocation").build()
    
    lazy var studentLocationsProperty : ApiProperty<StudentLocationsResponseBody> = ApiProperty(withId:  "DeleteSession", andRequest: studentLocationsRequest)
}
