//
//  ValidationRules.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 03/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

protocol ValidationRule{
    func isValid(text: String?) -> Bool
}

class NotEmptyValidationRule : ValidationRule{
    func isValid(text: String?) -> Bool {
        return text != nil && !text!.isEmpty
    }
}

class SameAsOtherValidationRule : ValidationRule{
    weak var other: UITextField?
    
    init(other: UITextField) {
        self.other = other
    }
    
    func isValid(text: String?) -> Bool {
        return text == other?.text
    }
}
