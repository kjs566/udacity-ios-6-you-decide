//
//  LoginViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class LoginViewModel: BaseViewModel{
    let loginState = ObservableProperty<AsyncResult<LoginResult>>()
    private let loginUC: LoginUseCase
    
    init(loginUC: LoginUseCase){
        self.loginUC = loginUC
    }
    
    func login(username: String, password: String){
        loginState.setValue(.loading)
        loginUC.execute(input: LoginInput(username: username, password: password)) { callbackResult in
            self.loginState.setValue(callbackResult.toResult())
        }
    }
}
