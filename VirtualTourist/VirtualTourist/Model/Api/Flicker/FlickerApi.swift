//
//  FlickerApi.swift
//  VirtualTourist
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class FlickerApi: BaseApi{
    private static let API_KEY = "70322c10d2442de9e91ef98d0438185d"
    private static let PAGE_SIZE = 20
    
    static let shared = FlickerApi()
    
    private init(){
        super.init(baseUrl: "https://api.flickr.com/services/rest/")
    }
    
    override func requestBuilder<R>() -> ApiRequest<R>.Builder where R : Decodable {
        return super
            .requestBuilder()
            .addHeader(key: "Accept", value: "application/json")
            .addHeader(key: "Content-Type", value: "application/json")
            .addQueryArgument(key: "format", value: "json")
            .addQueryArgument(key: "nojsoncallback", value: "1")
    }
    
    func getSeachPhotosRequest(lon: Double, lat: Double, page: Int) -> ApiRequest<PhotosResponse>{
        return requestBuilder()
            .addQueryArgument(key: "method", value: "flickr.photos.search")
            .addQueryArgument(key: "api_key", value: FlickerApi.API_KEY)
            .addQueryArgument(key: "lon", value: String(lon))
            .addQueryArgument(key: "lat", value: String(lat))
            .addQueryArgument(key: "per_page", value: String(FlickerApi.PAGE_SIZE))
            .addQueryArgument(key: "page",value: String(page))
            .build()
    }
    
    func getSearchPhotosProperty(lon: Double, lat: Double, page: Int) -> ApiProperty<PhotosResponse>{
        return ApiProperty<PhotosResponse>(withId: "SeachPhotos", andRequest: getSeachPhotosRequest(lon: lon, lat: lat, page: page))
    }
}
