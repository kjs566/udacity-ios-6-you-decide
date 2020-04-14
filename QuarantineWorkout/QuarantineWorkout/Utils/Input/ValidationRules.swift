//
//  ValidationRules.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 03/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

protocol ValidationRule{
    func isValid(text: String?) -> Bool
}

class NotEmptyValidationRule : ValidationRule{
    func isValid(text: String?) -> Bool {
        return text != nil && !text!.isEmpty
    }
}
