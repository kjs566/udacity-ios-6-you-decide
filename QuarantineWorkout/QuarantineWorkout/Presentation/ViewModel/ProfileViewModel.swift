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

    let state = ObservableProperty<AsyncResult<Void>>()
    let finishedPlans = ObservableProperty<Int>()
    let totalCalories = ObservableProperty<Int>()
    
    override init(logoutUC: LogoutUseCase) {
        super.init(logoutUC: logoutUC)
        
        let property = CoreDataCollectionProperty<FinishedPlan>(entityName: "FinishedPlan", withId: "FinishedPlans")
        propertyObserver.observeProperty(property) { (result: CoreDataResult<FinishedPlan>?) in
            result?.handle(success: { (plans: Array<FinishedPlan>?) in
                DispatchQueue.global(qos: .background).async { // Would be much better to do sum at SQL level, but this is only MVP :D
                    self.finishedPlans.setValue(plans?.count ?? 0)
                    
                    var calories = 0
                    
                    if plans != nil{
                        for plan in plans!{
                            calories = calories + Int(plan.calories)
                        }
                    }
                    
                    self.totalCalories.setValue(calories)
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
