//
//  TextFieldStyle.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 03/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldStyle{
    func styleValid(textField: UITextField)
    func styleInvalid(textField: UITextField)
    func styleInitial(textField: UITextField)
}

class InputFieldStyle : TextFieldStyle{
    func styleInitial(textField: UITextField){
        styleValid(textField: textField)
    }
    
    func styleInvalid(textField: UITextField){
        textField.layer.borderColor = UIColor(named: "InvalidColor")?.cgColor
        textField.layer.borderWidth = 1.0
    }
    func styleValid(textField: UITextField){
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
    }
}

