//
//  KeyboardHeightHandler.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 03/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

// TODO better name...
class KeyboardHeightHandler{
    weak var currentlyEditingField: UITextField? = nil
    weak var controller: UIViewController? = nil
    var textViews: [UITextField]? = nil

    func startHandling(controller: UIViewController, textFields: [UITextField]){
        self.controller = controller
        self.textViews = textFields
        
        textFields.forEach { (textField) in
            NotificationCenter.default.addObserver(self, selector: #selector(textBeginEditing(notification:)), name: UITextField.textDidBeginEditingNotification, object: textField)
        }
        
        subscribeKeyboardShowHide()
    }
    
    func stopHandling(){
        textViews?.forEach { (textView) in
            NotificationCenter.default.removeObserver(textView, name: UITextField.textDidBeginEditingNotification, object: nil)
        }
        
        unsubscribeKeyboardShowHide()
        
        controller = nil
        textViews = nil
        currentlyEditingField = nil
    }
    
    @objc func textBeginEditing(notification: Notification){
        currentlyEditingField = notification.object as? UITextField
    }
    
    func subscribeKeyboardShowHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardShowHide(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        let keyboardHeight = getKeyboardHeight(notification)
        
        let viewTopY = currentlyEditingField?.convert(CGPoint.zero, to: controller?.view).y ?? 0
        let viewBottomY = currentlyEditingField?.convert(CGPoint(x: 0, y: currentlyEditingField?.bounds.maxY ?? 0), to: controller?.view).y ?? 0
        
        let viewCenterY = viewTopY + viewBottomY / 2
        let totalHeight = controller?.view.bounds.height ?? 0
        
        var y : CGFloat = -keyboardHeight + (totalHeight - viewCenterY) - 50 // Move view above keyboard (with  offset)
        if y < -keyboardHeight {
            y = -keyboardHeight
        }
        controller?.view.frame.origin.y = y
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        resetFrameOrigin()
    }
    
    func resetFrameOrigin(){
        controller?.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
