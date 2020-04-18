//
//  ApiClient.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ApiClient: BaseApi{
    static let shared = ApiClient()
    
    private init(){
        super.init(baseUrl: "https://quarantine-workout-cc7ea.firebaseapp.com/")
    }
    
    func getWeeklyChallangeRequest() -> ApiRequest<WeeklyChallangeResponse>{
        return requestBuilder()
            .path("workoutapp-weeklychallange.json")
            .build()
    }
}
