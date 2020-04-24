//
//  ProfileViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ProfileViewModel: TabRootViewModel{
    private let propertyObserver = PropertyObserver()
    
    let userEmail = ObservableProperty<String>()

    let state = ObservableProperty<AsyncResult<Void>>()
    let finishedPlans = ObservableProperty<Int>()
    let totalCalories = ObservableProperty<Int>()
    let totalTime = ObservableProperty<Int>()
    let totalReps = ObservableProperty<Int>()
    let totalSets = ObservableProperty<Int>()
    let loginsCount = ObservableProperty<Int>()
    
    init(logoutUC: LogoutUseCase, getEmailUC: GetUserEmailUseCase) {
        super.init(logoutUC: logoutUC)
        
        loginsCount.setValue(UserDefaults.standard.integer(forKey: "loginsCount"))
        userEmail.setValue(getEmailUC.execute(input: None.NONE))
        
        let property = CoreDataCollectionProperty<FinishedPlan>(entityName: "FinishedPlan", withId: "FinishedPlans") // Would be nice to move this to repository...
        propertyObserver.observeProperty(property) { (result: CoreDataResult<FinishedPlan>?) in
            result?.handle(success: { (plans: Array<FinishedPlan>?) in
                DispatchQueue.global(qos: .background).async { // Would be much better to do sum at SQL level, but this is only MVP :D
                    self.finishedPlans.setValue(plans?.count ?? 0)
                    
                    var calories = 0
                    var totalTime = 0
                    var totalReps = 0
                    var totalSets = 0
                    
                    if plans != nil{
                        for plan in plans!{
                            calories = calories + Int(plan.calories)
                            totalTime = totalTime + Int(plan.duration)
                            totalReps = totalReps + Int(plan.totalReps)
                            totalSets = totalSets + Int(plan.workoutsCount)
                        }
                    }
                    
                    self.totalCalories.setValue(calories)
                    self.totalReps.setValue(totalReps)
                    self.totalSets.setValue(totalSets)
                    self.totalTime.setValue(totalTime)
                    self.state.setValue(.success(nil))
                }
            }, error: { error in
                self.state.setValue(.error(error))
            },loading: {
                self.state.setValue(.loading)
            })
        }
        
    }
    
    deinit {
        propertyObserver.dispose()
    }
}
