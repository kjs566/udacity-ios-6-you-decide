//
//  ApiRepository.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ApiRepository: BaseRepository{
    let shared = ApiRepository()
    
    lazy var weeklyChallangeProperty = ApiProperty<WeeklyChallangeResponse>(withId: "Weekly challange property", andRequest: ApiClient.shared.getWeeklyChallangeRequest())
}
