//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : BaseViewController<LoginViewModel, InitialFlowCoordinator>{
    @IBOutlet weak var userNameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let keyboardHeightHandler = KeyboardHeightHandler()

    lazy var userNameValidator = InputValidator()
    lazy var passwordValidator = InputValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        observeProperty(getVM().loginState){ (property) in
            guard let property = property else { return }

            switch property {
                case .loading:
                    self.showLoading()
                    self.disableInput()
                case .error(let error):
                    self.handleError(error)
                    self.hideLoading()
                    self.enableInput()
                case .success:
                    self.hideLoading()
                    self.clearInput()
                    self.getFlowCoordinator().showMain(source: self)
                    self.enableInput()
            }
        }
        
        observeDependent(userNameValidator.validityObservable, passwordValidator.validityObservable){ validUser, validPassword in
            self.updateLoginButtonEnabled(valid: validUser ?? false && validPassword ?? false)
        }
        
        keyboardHeightHandler.startHandling(controller: self, textFields: [userNameView, passwordView])
        userNameValidator.startValidating(textField: userNameView)
        passwordValidator.startValidating(textField: passwordView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableInput()
        hideLoading()
        
        userNameView.text = "test@test.test" // TODO remove
        passwordView.text = "testtest"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHeightHandler.stopHandling()
    }
    
    deinit {
        userNameValidator.stopValidating()
        passwordValidator.stopValidating()
    }
    
    func setupViews(){
        loginButton.setTitleColor(.black, for: .selected)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        
        passwordView.delegate = self
        userNameView.delegate = self
    }

    
    @IBAction func loginClicked(_ sender: Any) {
            login()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        getFlowCoordinator().showSignUp(source: self)
    }
    
    func updateLoginButtonEnabled(valid: Bool){
        if valid {
            loginButton.backgroundColor = UIColor(named: "UdacityColor")
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
        }
    }
    
    func login(){
        guard let username = userNameView.text, let password = passwordView.text else { return }
    
        getVM().login(username: username, password: password)
    }
    
    func enableInput(){
        loginButton.isEnabled = true
        passwordView.isEnabled = true
        userNameView.isEnabled = true
        aboutButton.isEnabled = true
    }
    
    func disableInput(){
        loginButton.isEnabled = false
        passwordView.isEnabled = false
        userNameView.isEnabled = false
        aboutButton.isEnabled = false
    }
    
    func clearInput(){
        //passwordView.text = ""
        //userNameView.text = ""
        
        // TODO UNCOMMENT
    }
    
    func showLoading(){
        activityIndicator.isHidden = false
    }
    
    func hideLoading(){
        activityIndicator.isHidden = true
    }
}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
