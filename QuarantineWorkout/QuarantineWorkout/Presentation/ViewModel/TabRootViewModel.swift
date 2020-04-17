//
//  TabRootViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class TabRootViewModel: BaseViewModel{
    private let logoutUC: LogoutUseCase
    let logoutState = ObservableProperty<AsyncResult<LogoutResult>>()
    
    init(logoutUC: LogoutUseCase){
        self.logoutUC = logoutUC
    }
    
    
    func logout(){
        logoutState.setValue(.loading)
        logoutUC.execute(input: None.NONE) { callbackResult in
            self.logoutState.setValue(callbackResult.toResult())
        }
    }
}
