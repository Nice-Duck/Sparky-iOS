//
//  OTPTextField.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/03.
//

import UIKit

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override public func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
