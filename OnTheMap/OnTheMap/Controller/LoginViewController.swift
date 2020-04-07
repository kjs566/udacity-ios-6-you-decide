//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : PropertyObserverController{
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
        
        observeProperty(UdacityApi.shared.createSessionProperty){ (property) in
            guard let property = property else { return }

            switch property.state {
                case .idle: break
                case .loading:
                    self.showLoading()
                    self.disableInput()
                case .error:
                    self.handleError(property.error)
                    self.hideLoading()
                    self.enableInput()
                case .success:
                    self.hideLoading()
                    self.clearInput()
                    if let userId = property.value?.account.key{
                        UdacityApi.shared.loadUserProfile(userId: userId)
                    }
                    self.performSegue(withIdentifier: "showLocationSegue", sender: nil)
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
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func updateLoginButtonEnabled(valid: Bool){
        if(valid){
            loginButton.backgroundColor = UIColor(named: "UdacityColor")
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
        }
    }
    
    func login(){
        guard let username = userNameView.text, let password = passwordView.text else { return }
        UdacityApi.shared.createSession(username: username, password: password)
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
        passwordView.text = ""
        userNameView.text = ""
    }
    
    func showLoading(){
        activityIndicator.isHidden = false
    }
    
    func hideLoading(){
        activityIndicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is UITabBarController){
            let vc = segue.destination as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
        }
    }
}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
