//
//  InputValidator.swift
//  VirtualTourist
//
//  Created by Jan Skála on 03/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class InputValidator{
    weak var textField: UITextField? = nil
    var validationRules : [ValidationRule] = []
    var autoApplyStyle : TextFieldStyle? = nil
    
    var onValid : ((UITextField)->Void)? = nil
    var onInvalid : ((UITextField)->Void)? = nil
    
    public let validityObservable = ObservableProperty<Bool>()

    public static var notEmptyRule = NotEmptyValidationRule()
    
    func startValidating(
        textField: UITextField,
        validationRules: [ValidationRule] = [notEmptyRule],
        autoApplyStyle: TextFieldStyle? = InputFieldStyle(),
        onValid: ((UITextField)->Void)? = nil,
        onInvalid: ((UITextField)->Void)? = nil
    ){
        self.textField = textField
        self.validationRules = validationRules
        self.autoApplyStyle = autoApplyStyle
        self.onValid = onValid
        self.onInvalid = onInvalid
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(endedEditing), name: UITextField.textDidEndEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(startedEditing), name: UITextField.textDidBeginEditingNotification, object: textField)
        
        applyStyleInitial()
        validate(updateView: false)
    }
    
    func stopValidating(){
        NotificationCenter.default.removeObserver(self)
        
        onValid = nil
        onInvalid = nil
        textField = nil
    }
    
    @objc func startedEditing(){
        applyStyleInitial()
        validate(updateView: false)
    }
    
    @objc func endedEditing(){
        validate(updateView: true)
    }
    
    @objc func textChanged(){
        validate(updateView: false)
    }
    
    func validate(updateView: Bool){
        if isValid() {
            if updateView {
                applyStyleValid()
            }
            if let onValid = onValid, let textField = textField{
                onValid(textField)
            }
            validityObservable.setValue(true)
        }else{
            if updateView {
                applyStyleInvalid()
            }
            if let onInvalid = onInvalid, let textField = textField{
                onInvalid(textField)
            }
            validityObservable.setValue(false)
        }
    }
    
    func isValid() -> Bool{
        let text = textField?.text
        
        for rule in validationRules{
            if !rule.isValid(text: text){
                return false
            }
        }
        
        return true
    }
    
    private func applyStyleInitial(){
        guard let textField = textField else { return }
        autoApplyStyle?.styleInitial(textField: textField)
    }
    
    private func applyStyleValid(){
        guard let textField = textField else { return }
        autoApplyStyle?.styleValid(textField: textField)
    }
    
    private func applyStyleInvalid(){
        guard let textField = textField else { return }
        autoApplyStyle?.styleInvalid(textField: textField)
    }
}
