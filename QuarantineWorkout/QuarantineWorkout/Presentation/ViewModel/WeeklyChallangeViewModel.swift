//
//  WeeklyChallangeViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WeeklyChallangeViewModel: TabRootViewModel{
    private let getWeeklyChallangeUC: GetWeeklyChallangeUseCase
    
    let weeklyChallange: ApiProperty<WeeklyChallangeResponse>
    
    init(logoutUC: LogoutUseCase, getWeeklyChallangeUC: GetWeeklyChallangeUseCase){
        self.getWeeklyChallangeUC = getWeeklyChallangeUC
        self.weeklyChallange = getWeeklyChallangeUC.execute(input: None.NONE)!
        super.init(logoutUC: logoutUC)
    }
    
    func loadWeeklyChallange(){
        weeklyChallange.load()
    }
    
}
