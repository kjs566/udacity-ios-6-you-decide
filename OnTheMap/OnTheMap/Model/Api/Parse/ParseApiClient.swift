//
//  ParseApiClient.swift
//  OnTheMap
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ParseApiClient : BaseApiClient{
    public init(){
        super.init(baseUrl: "https://onthemap-api.udacity.com")
    }
    
    lazy var studentLocationsRequest : ApiRequest<StudentLocations> = requestBuilder().path(path: "/v1/StudentLocation").build()
    
    lazy var studentLocationsProperty : ApiProperty<StudentLocations> = ApiProperty(withRequest: studentLocationsRequest)
}
