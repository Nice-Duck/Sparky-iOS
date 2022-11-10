//
//  OTPStackView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/03.
//

import Foundation
import UIKit

protocol OTPDelegate: AnyObject {
    func didChangeValidity(isValid: Bool)
}

class OTPStackView: UIStackView {
    
    // Customise the OTP Field here
    let numberOfFields = 6
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    var remainingStringStack: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        setupStackView()
        addOTPField()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private final func setupStackView() {
        self.backgroundColor = .sparkyWhite
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    private final func addOTPField() {
        for index in 0..<numberOfFields {
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            
            // Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index - 1]) : (field.previousTextField = nil)
            // Adding a marker to next field for the field at index - 1
            index != 0 ? (textFieldsCollection[index - 1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    private final func setupTextField(_ textField: OTPTextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.backgroundColor = .sparkyWhite
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = .bodyRegular2
        textField.textColor = .sparkyBlack
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray300.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
    }
    
    private final func checkForValidity() {
        for fields in textFieldsCollection {
            if fields.text == "" {
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection {
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor) {
        for textField in textFieldsCollection {
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    private final func autoFillTextField(with string: String) {
        remainingStringStack = string.reversed().compactMap({ String($0) })
        for textField in textFieldsCollection {
            if let charToAdd = remainingStringStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStringStack = []
    }
}

extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
//            setAllFieldColor(color: .sparkyOrange)
            showsWarningColor = false
        }
        textField.layer.borderColor = UIColor.sparkyBlack.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
//        textField.layer.borderColor = UIColor.orange.cgColor
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if range.length == 0 {
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                } else {
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
}
